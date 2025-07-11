// models/download_models.dart
import 'dart:developer';

import 'package:flutter_downloader/flutter_downloader.dart';

// cubit/download_cubit.dart
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// screens/download_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

enum DownloadItemStatus {
  enqueued,
  running,
  complete,
  failed,
  canceled,
  paused,
}

class DownloadItem {
  final String id;
  final String url;
  final String fileName;
  final String subjectId;
  String? taskId;
  DownloadItemStatus status;
  int progress;

  DownloadItem({
    required this.id,
    required this.url,
    required this.fileName,
    required this.subjectId,
    this.taskId,
    this.status = DownloadItemStatus.enqueued,
    this.progress = 0,
  });

  DownloadItem copyWith({
    String? taskId,
    DownloadItemStatus? status,
    int? progress,
  }) {
    return DownloadItem(
      id: id,
      url: url,
      fileName: fileName,
      subjectId: subjectId,
      taskId: taskId ?? this.taskId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}

class SubjectDownloads {
  final String subjectId;
  final String subjectName;
  final List<DownloadItem> items;

  SubjectDownloads({
    required this.subjectId,
    required this.subjectName,
    required this.items,
  });

  int get totalProgress {
    if (items.isEmpty) return 0;
    return items.map((e) => e.progress).reduce((a, b) => a + b) ~/ items.length;
  }

  int get completedCount =>
      items.where((e) => e.status == DownloadItemStatus.complete).length;
  int get failedCount =>
      items.where((e) => e.status == DownloadItemStatus.failed).length;
  int get runningCount =>
      items.where((e) => e.status == DownloadItemStatus.running).length;
  int get pausedCount =>
      items.where((e) => e.status == DownloadItemStatus.paused).length;

  bool get isAllCompleted =>
      items.every((e) => e.status == DownloadItemStatus.complete);
  bool get hasRunningItems =>
      items.any((e) => e.status == DownloadItemStatus.running);
  bool get hasPausedItems =>
      items.any((e) => e.status == DownloadItemStatus.paused);
}

// cubit/download_state.dart
class DownloadState {
  final List<SubjectDownloads> subjects;
  final bool isInitialized;
  final String? error;

  const DownloadState({
    this.subjects = const [],
    this.isInitialized = false,
    this.error,
  });

  DownloadState copyWith({
    List<SubjectDownloads>? subjects,
    bool? isInitialized,
    String? error,
  }) {
    return DownloadState(
      subjects: subjects ?? this.subjects,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }

  int get totalProgress {
    if (subjects.isEmpty) return 0;
    final totalItems = subjects.expand((s) => s.items).length;
    if (totalItems == 0) return 0;
    final totalProgress = subjects
        .expand((s) => s.items)
        .map((e) => e.progress)
        .reduce((a, b) => a + b);
    return totalProgress ~/ totalItems;
  }

  int get totalCompleted =>
      subjects
          .expand((s) => s.items)
          .where((e) => e.status == DownloadItemStatus.complete)
          .length;
  int get totalItems => subjects.expand((s) => s.items).length;
}

@pragma('vm:entry-point')
class DownloadCubit extends Cubit<DownloadState> {
  static const String _portName = 'downloader_send_port';
  final ReceivePort _port = ReceivePort();

  @pragma('vm:entry-point')
  DownloadCubit() : super(const DownloadState()) {
    _bindBackgroundIsolate();
    _initializeDownloader();
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      _portName,
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;
      _updateDownloadProgress(taskId, status, progress);
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(_portName);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(_portName);
    // send?.send([id, status, progress]);
    if (send != null) {
      send.send([id, status, progress]);
    } else {
      debugPrint("❌ SendPort not found for $_portName in downloadCallback");
    }
  }

  Future<void> _initializeDownloader() async {
    // await FlutterDownloader.initialize(debug: true);
    FlutterDownloader.registerCallback(downloadCallback);
    await _requestPermissions();
    emit(state.copyWith(isInitialized: true));
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.notification.request();
    }
  }

  Future<void> startSubjectDownloads({
    required String subjectId,
    required String subjectName,
    required List<Map<String, String>>
    imageUrls, // {url: string, fileName: string}
  }) async {
    try {
      final downloadItems =
          imageUrls
              .map(
                (imageData) => DownloadItem(
                  id:
                      '${subjectId}_${DateTime.now().millisecondsSinceEpoch}_${imageUrls.indexOf(imageData)}',
                  url: imageData['url']!,
                  fileName: imageData['fileName']!,
                  subjectId: subjectId,
                ),
              )
              .toList();

      final subjectDownloads = SubjectDownloads(
        subjectId: subjectId,
        subjectName: subjectName,
        items: downloadItems,
      );

      final updatedSubjects = [...state.subjects, subjectDownloads];
      emit(state.copyWith(subjects: updatedSubjects));

      // Start downloading the first item
      _startNextDownload(subjectId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _startNextDownload(String subjectId) async {
    final subject = state.subjects.firstWhere((s) => s.subjectId == subjectId);
    final nextItem = subject.items.firstWhere(
      (item) => item.status == DownloadItemStatus.enqueued,
      orElse: () => DownloadItem(id: '', url: '', fileName: '', subjectId: ''),
    );

    if (nextItem.id.isEmpty) return; // No more items to download

    try {
      final baseDir =
          await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();

      log(baseDir.path);

      final saveDir = Directory('${baseDir.path}/$subjectId');

      // Ensure the directory exists
      if (!(await saveDir.exists())) {
        await saveDir.create(recursive: true);
      }

      final taskId = await FlutterDownloader.enqueue(
        url: nextItem.url,
        savedDir: saveDir.path,
        fileName: nextItem.fileName,
        showNotification: true,
        openFileFromNotification: false,
        saveInPublicStorage: false,
      );

      _updateItemStatus(
        nextItem.id,
        DownloadItemStatus.running,
        taskId: taskId,
      );
    } catch (e) {
      print("Download failed: $e");
      _updateItemStatus(nextItem.id, DownloadItemStatus.failed);
    }
  }

  void _updateDownloadProgress(
    String taskId,
    DownloadTaskStatus status,
    int progress,
  ) {
    final subjects =
        state.subjects.map((subject) {
          final items =
              subject.items.map((item) {
                if (item.taskId == taskId) {
                  final newStatus = _mapDownloadStatus(status);
                  final updatedItem = item.copyWith(
                    status: newStatus,
                    progress: progress,
                  );

                  // Start next download if this one completed
                  if (newStatus == DownloadItemStatus.complete ||
                      newStatus == DownloadItemStatus.failed ||
                      newStatus == DownloadItemStatus.paused ||
                      newStatus == DownloadItemStatus.canceled) {
                    Future.delayed(
                      Duration.zero,
                      () => _startNextDownload(subject.subjectId),
                    );
                  }

                  return updatedItem;
                }
                return item;
              }).toList();

          return SubjectDownloads(
            subjectId: subject.subjectId,
            subjectName: subject.subjectName,
            items: items,
          );
        }).toList();

    emit(state.copyWith(subjects: subjects));
  }

  void _updateItemStatus(
    String itemId,
    DownloadItemStatus status, {
    String? taskId,
  }) {
    final subjects =
        state.subjects.map((subject) {
          final items =
              subject.items.map((item) {
                if (item.id == itemId) {
                  return item.copyWith(status: status, taskId: taskId);
                }
                return item;
              }).toList();

          return SubjectDownloads(
            subjectId: subject.subjectId,
            subjectName: subject.subjectName,
            items: items,
          );
        }).toList();

    emit(state.copyWith(subjects: subjects));
  }

  DownloadItemStatus _mapDownloadStatus(DownloadTaskStatus status) {
    switch (status) {
      case DownloadTaskStatus.enqueued:
        return DownloadItemStatus.enqueued;
      case DownloadTaskStatus.running:
        return DownloadItemStatus.running;
      case DownloadTaskStatus.complete:
        return DownloadItemStatus.complete;
      case DownloadTaskStatus.failed:
        return DownloadItemStatus.failed;
      case DownloadTaskStatus.canceled:
        return DownloadItemStatus.canceled;
      case DownloadTaskStatus.paused:
        return DownloadItemStatus.paused;
      default:
        return DownloadItemStatus.enqueued;
    }
  }

  // Control methods
  Future<void> pauseItem(String itemId) async {
    final item = _findItemById(itemId);
    if (item?.taskId != null) {
      await FlutterDownloader.pause(taskId: item!.taskId!);
    }
  }

  Future<void> resumeItem(String itemId) async {
    final item = _findItemById(itemId);
    if (item?.taskId != null) {
      await FlutterDownloader.resume(taskId: item!.taskId!);
    }
  }

  Future<void> cancelItem(String itemId) async {
    final item = _findItemById(itemId);
    if (item?.taskId != null) {
      await FlutterDownloader.cancel(taskId: item!.taskId!);
    }
  }

  Future<void> retryItem(String itemId) async {
    final item = _findItemById(itemId);
    if (item != null) {
      try {
        final directory = await getExternalStorageDirectory();
        final taskId = await FlutterDownloader.enqueue(
          url: item.url,
          savedDir: '${directory!.path}/${item.subjectId}',
          fileName: item.fileName,
          showNotification: true,
          openFileFromNotification: false,
        );
        _updateItemStatus(item.id, DownloadItemStatus.running, taskId: taskId);
      } catch (e) {
        _updateItemStatus(item.id, DownloadItemStatus.failed);
      }
    }
  }

  // Subject-level controls
  Future<void> pauseSubject(String subjectId) async {
    final subject = state.subjects.firstWhere((s) => s.subjectId == subjectId);
    for (final item in subject.items) {
      if (item.status == DownloadItemStatus.running ||
          item.status == DownloadItemStatus.enqueued && item.taskId != null) {
        await FlutterDownloader.pause(taskId: item.taskId!);
      }
    }
  }

  Future<void> resumeSubject(String subjectId) async {
    final subject = state.subjects.firstWhere((s) => s.subjectId == subjectId);
    for (final item in subject.items) {
      if (item.status == DownloadItemStatus.paused && item.taskId != null) {
        await FlutterDownloader.resume(taskId: item.taskId!);
      }
    }
  }

  Future<void> cancelSubject(String subjectId) async {
    final subject = state.subjects.firstWhere((s) => s.subjectId == subjectId);
    for (final item in subject.items) {
      if (item.taskId != null) {
        await FlutterDownloader.cancel(taskId: item.taskId!);
      }
    }
  }

  // Global controls
  Future<void> pauseAll() async {
    for (final subject in state.subjects) {
      await pauseSubject(subject.subjectId);
    }
  }

  Future<void> resumeAll() async {
    for (final subject in state.subjects) {
      await resumeSubject(subject.subjectId);
    }
  }

  Future<void> cancelAll() async {
    for (final subject in state.subjects) {
      await cancelSubject(subject.subjectId);
    }
  }

  DownloadItem? _findItemById(String itemId) {
    for (final subject in state.subjects) {
      for (final item in subject.items) {
        if (item.id == itemId) return item;
      }
    }
    return null;
  }

  @override
  Future<void> close() {
    _unbindBackgroundIsolate();
    return super.close();
  }
}

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          BlocBuilder<DownloadCubit, DownloadState>(
            builder: (context, state) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  final cubit = context.read<DownloadCubit>();
                  switch (value) {
                    case 'pause_all':
                      cubit.pauseAll();
                      break;
                    case 'resume_all':
                      cubit.resumeAll();
                      break;
                    case 'cancel_all':
                      cubit.cancelAll();
                      break;
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'pause_all',
                        child: Text('Pause All'),
                      ),
                      const PopupMenuItem(
                        value: 'resume_all',
                        child: Text('Resume All'),
                      ),
                      const PopupMenuItem(
                        value: 'cancel_all',
                        child: Text('Cancel All'),
                      ),
                    ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DownloadCubit, DownloadState>(
        builder: (context, state) {
          if (!state.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.subjects.isEmpty) {
            return const Center(child: Text('No downloads yet'));
          }

          return Column(
            children: [
              // Overall progress
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircularProgressIndicator(
                          value: state.totalProgress / 100,
                          strokeWidth: 3,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overall Progress',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${state.totalCompleted}/${state.totalItems} completed',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Subjects list
              Expanded(
                child: ListView.builder(
                  itemCount: state.subjects.length,
                  itemBuilder: (context, index) {
                    final subject = state.subjects[index];
                    return SubjectDownloadCard(subject: subject);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// widgets/subject_download_card.dart
class SubjectDownloadCard extends StatefulWidget {
  final SubjectDownloads subject;

  const SubjectDownloadCard({super.key, required this.subject});

  @override
  State<SubjectDownloadCard> createState() => _SubjectDownloadCardState();
}

class _SubjectDownloadCardState extends State<SubjectDownloadCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircularProgressIndicator(
              value: widget.subject.totalProgress / 100,
              strokeWidth: 3,
            ),
            title: Text(widget.subject.subjectName),
            subtitle: Text(
              '${widget.subject.completedCount}/${widget.subject.items.length} completed',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    final cubit = context.read<DownloadCubit>();
                    switch (value) {
                      case 'pause':
                        cubit.pauseSubject(widget.subject.subjectId);
                        break;
                      case 'resume':
                        cubit.resumeSubject(widget.subject.subjectId);
                        break;
                      case 'cancel':
                        cubit.cancelSubject(widget.subject.subjectId);
                        break;
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'pause',
                          child: Text('Pause'),
                        ),
                        const PopupMenuItem(
                          value: 'resume',
                          child: Text('Resume'),
                        ),
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Text('Cancel'),
                        ),
                      ],
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            ...widget.subject.items.map((item) => DownloadItemTile(item: item)),
          ],
        ],
      ),
    );
  }
}

// widgets/download_item_tile.dart
class DownloadItemTile extends StatelessWidget {
  final DownloadItem item;

  const DownloadItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            CircularProgressIndicator(
              value: item.progress / 100,
              strokeWidth: 2,
            ),
            Center(child: _getStatusIcon()),
          ],
        ),
      ),
      title: Text(item.fileName, style: const TextStyle(fontSize: 14)),
      subtitle: Text('${item.progress}% - ${_getStatusText()}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.status == DownloadItemStatus.running)
            IconButton(
              icon: const Icon(Icons.pause, size: 20),
              onPressed: () => context.read<DownloadCubit>().pauseItem(item.id),
            ),
          if (item.status == DownloadItemStatus.paused)
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 20),
              onPressed: () => context.read<DownloadCubit>().retryItem(item.id),
            ),
          if (item.status == DownloadItemStatus.failed)
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: () => context.read<DownloadCubit>().retryItem(item.id),
            ),
          if (item.status != DownloadItemStatus.complete)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed:
                  () => context.read<DownloadCubit>().cancelItem(item.id),
            ),
        ],
      ),
    );
  }

  Widget _getStatusIcon() {
    switch (item.status) {
      case DownloadItemStatus.complete:
        return const Icon(Icons.check, color: Colors.green, size: 16);
      case DownloadItemStatus.failed:
        return const Icon(Icons.error, color: Colors.red, size: 16);
      case DownloadItemStatus.paused:
        return const Icon(Icons.pause, color: Colors.orange, size: 16);
      case DownloadItemStatus.canceled:
        return const Icon(Icons.close, color: Colors.grey, size: 16);
      default:
        return const SizedBox.shrink();
    }
  }

  String _getStatusText() {
    switch (item.status) {
      case DownloadItemStatus.enqueued:
        return 'Waiting';
      case DownloadItemStatus.running:
        return 'Downloading';
      case DownloadItemStatus.complete:
        return 'Completed';
      case DownloadItemStatus.failed:
        return 'Failed';
      case DownloadItemStatus.canceled:
        return 'Canceled';
      case DownloadItemStatus.paused:
        return 'Paused';
    }
  }
}

// Usage example in main.dart or where you initialize the download:
/*
// To start downloads for a subject:
context.read<DownloadCubit>().startSubjectDownloads(
  subjectId: 'math_101',
  subjectName: 'Mathematics 101',
  imageUrls: [
    {'url': 'https://example.com/image1.jpg', 'fileName': 'image1.jpg'},
    {'url': 'https://example.com/image2.jpg', 'fileName': 'image2.jpg'},
    // ... more images
  ],
);
*/

// class SubjectsScreen extends StatelessWidget {
//   const SubjectsScreen({super.key});

//   // Mock data for testing
//   static final List<Subject> _mockSubjects = [
//     Subject(
//       id: 'math_101',
//       name: 'Mathematics 101',
//       description: 'Basic mathematics concepts and formulas',
//       imageCount: 25,
//       sampleImageUrls: List.generate(
//         25,
//         (index) => 'https://picsum.photos/400/600?random=${100 + index}',
//       ),
//     ),
//     Subject(
//       id: 'physics_201',
//       name: 'Physics 201',
//       description: 'Advanced physics theories and experiments',
//       imageCount: 40,
//       sampleImageUrls: List.generate(
//         40,
//         (index) => 'https://picsum.photos/400/600?random=${200 + index}',
//       ),
//     ),
//     Subject(
//       id: 'chemistry_301',
//       name: 'Chemistry 301',
//       description: 'Organic and inorganic chemistry',
//       imageCount: 30,
//       sampleImageUrls: List.generate(
//         30,
//         (index) => 'https://picsum.photos/400/600?random=${300 + index}',
//       ),
//     ),
//     Subject(
//       id: 'biology_401',
//       name: 'Biology 401',
//       description: 'Cell biology and genetics',
//       imageCount: 50,
//       sampleImageUrls: List.generate(
//         50,
//         (index) => 'https://picsum.photos/400/600?random=${400 + index}',
//       ),
//     ),
//     Subject(
//       id: 'history_501',
//       name: 'History 501',
//       description: 'World history and civilizations',
//       imageCount: 35,
//       sampleImageUrls: List.generate(
//         35,
//         (index) => 'https://picsum.photos/400/600?random=${500 + index}',
//       ),
//     ),
//     Subject(
//       id: 'english_601',
//       name: 'English Literature',
//       description: 'Classic and modern literature',
//       imageCount: 20,
//       sampleImageUrls: List.generate(
//         20,
//         (index) => 'https://picsum.photos/400/600?random=${600 + index}',
//       ),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subjects'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const DownloadScreen()),
//               );
//             },
//             tooltip: 'View Downloads',
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Select a subject to download images',
//               style: Theme.of(
//                 context,
//               ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.8,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: _mockSubjects.length,
//                 itemBuilder: (context, index) {
//                   final subject = _mockSubjects[index];
//                   return SubjectCard(
//                     subject: subject,
//                     onTap: () => _startDownload(context, subject),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _startDownload(BuildContext context, Subject subject) {
//     // Show confirmation dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text('Download ${subject.name}'),
//           content: Text(
//             'Do you want to download ${subject.imageCount} images from ${subject.name}?\n\n'
//             'This will start downloading all images one by one.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop();
//                 _initiateDownload(context, subject);
//               },
//               child: const Text('Download'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _initiateDownload(BuildContext context, Subject subject) {
//     // Prepare image URLs with file names
//     final imageUrls =
//         subject.sampleImageUrls.asMap().entries.map((entry) {
//           final index = entry.key;
//           final url = entry.value;
//           return {
//             'url': url,
//             'fileName': '${subject.id}_image_${index + 1}.jpg',
//           };
//         }).toList();

//     // Start the download using the DownloadCubit
//     context.read<DownloadCubit>().startSubjectDownloads(
//       subjectId: subject.id,
//       subjectName: subject.name,
//       imageUrls: imageUrls,
//     );

//     // Show success message and navigate to downloads
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Started downloading ${subject.name}'),
//         action: SnackBarAction(
//           label: 'View Downloads',
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const DownloadScreen()),
//             );
//           },
//         ),
//       ),
//     );

//     // Optional: Auto-navigate to downloads screen
//     Future.delayed(const Duration(seconds: 1), () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const DownloadScreen()),
//       );
//     });
//   }
// }

// class SubjectCard extends StatelessWidget {
//   final Subject subject;
//   final VoidCallback onTap;

//   const SubjectCard({super.key, required this.subject, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Subject icon/image placeholder
//               Container(
//                 width: double.infinity,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       _getSubjectColor(subject.id),
//                       _getSubjectColor(subject.id).withOpacity(0.7),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   _getSubjectIcon(subject.id),
//                   size: 40,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Subject name
//               Text(
//                 subject.name,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),

//               // Description
//               Text(
//                 subject.description,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const Spacer(),

//               // Image count and download button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${subject.imageCount} images',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       fontWeight: FontWeight.w500,
//                       color: _getSubjectColor(subject.id),
//                     ),
//                   ),
//                   Icon(
//                     Icons.download,
//                     color: _getSubjectColor(subject.id),
//                     size: 20,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getSubjectColor(String subjectId) {
//     switch (subjectId) {
//       case 'math_101':
//         return Colors.blue;
//       case 'physics_201':
//         return Colors.purple;
//       case 'chemistry_301':
//         return Colors.green;
//       case 'biology_401':
//         return Colors.orange;
//       case 'history_501':
//         return Colors.brown;
//       case 'english_601':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getSubjectIcon(String subjectId) {
//     switch (subjectId) {
//       case 'math_101':
//         return Icons.calculate;
//       case 'physics_201':
//         return Icons.science;
//       case 'chemistry_301':
//         return Icons.biotech;
//       case 'biology_401':
//         return Icons.local_florist;
//       case 'history_501':
//         return Icons.history_edu;
//       case 'english_601':
//         return Icons.menu_book;
//       default:
//         return Icons.school;
//     }
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => DownloadCubit(),
//       child: MaterialApp(
//         title: 'Download Manager',
//         theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
//         home: const SubjectsScreen(),
//       ),
//     );
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize flutter_downloader
//   await FlutterDownloader.initialize(
//     debug:
//         true, // optional: set to false to disable printing logs to console (default: true)
//     ignoreSsl:
//         true, // option: set to false to disable working with http links (default: false)
//   );
//   runApp(const MyApp());
// }
