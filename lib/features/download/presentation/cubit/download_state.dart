// ==================== STATE ====================
part of 'download_cubit.dart';

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
}
