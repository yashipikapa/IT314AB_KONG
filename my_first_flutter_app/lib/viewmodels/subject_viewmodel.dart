import 'package:flutter/foundation.dart';
import '../core/error_mapper.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';

class SubjectViewModel extends ChangeNotifier {
  SubjectViewModel({SubjectRepository? repository}) : _repo = repository ?? SubjectRepository();

  final SubjectRepository _repo;

  List<Subject> subjects = [];
  Subject? selectedSubject;
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  void select(Subject? subject) {
    selectedSubject = subject;
    notifyListeners();
  }

  Future<void> loadSubjects() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      subjects = await _repo.getAll();
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> saveSubject(Subject subject) => _run(() async {
        if (subject.id == null) {
          await _repo.create(subject);
        } else {
          await _repo.update(subject);
        }
        subjects = await _repo.getAll();
      });

  Future<bool> deleteSubject(int id) => _run(() async {
        await _repo.delete(id);
        subjects = await _repo.getAll();
      });

  Future<bool> _run(Future<void> Function() action) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    var ok = true;
    try {
      await action();
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
      ok = false;
    }
    isSaving = false;
    notifyListeners();
    return ok;
  }
}
