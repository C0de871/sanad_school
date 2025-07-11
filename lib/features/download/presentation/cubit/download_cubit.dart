import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/subject_download.dart';
import '../../domain/repository/download_repository.dart';
part 'download_state.dart';

// ==================== CUBIT ====================
class DownloadCubit extends Cubit<DownloadState> {
  final DownloadRepository _repository;
  StreamSubscription<List<SubjectDownloads>>? _downloadsSubscription;
  StreamSubscription<String?>? _errorSubscription;

  DownloadCubit(this._repository) : super(const DownloadState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _repository.initialize();

    _downloadsSubscription = _repository.downloadsStream.listen((subjects) {
      emit(state.copyWith(subjects: subjects, isInitialized: true));
    });

    _errorSubscription = _repository.errorStream.listen((error) {
      if (error != null) {
        emit(state.copyWith(error: error));
      }
    });
  }

  // Delegate methods to repository
  Future<void> startSubjectDownloads({
    required String subjectId,
    required String subjectName,
    required imageUrls,
  }) async {
    await _repository.startSubjectDownloads(
      subjectId: subjectId,
      subjectName: subjectName,
      imageUrls: imageUrls,
    );
  }

  Future<void> pauseItem(String itemId) async {
    await _repository.pauseItem(itemId);
  }

  Future<void> resumeItem(String itemId) async {
    await _repository.resumeItem(itemId);
  }

  Future<void> cancelItem(String itemId) async {
    await _repository.cancelItem(itemId);
  }

  Future<void> retryItem(String itemId) async {
    await _repository.retryItem(itemId);
  }

  Future<void> pauseSubject(String subjectId) async {
    await _repository.pauseSubject(subjectId);
  }

  Future<void> resumeSubject(String subjectId) async {
    await _repository.resumeSubject(subjectId);
  }

  Future<void> cancelSubject(String subjectId) async {
    await _repository.cancelSubject(subjectId);
  }

  Future<void> pauseAll() async {
    await _repository.pauseAll();
  }

  Future<void> resumeAll() async {
    await _repository.resumeAll();
  }

  Future<void> cancelAll() async {
    await _repository.cancelAll();
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  @override
  Future<void> close() async {
    await _downloadsSubscription?.cancel();
    await _errorSubscription?.cancel();
    _repository.dispose();
    return super.close();
  }
}
