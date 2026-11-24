import 'package:flutter/foundation.dart';
import '../core/error_mapper.dart';
import '../models/program.dart';
import '../models/student.dart';
import '../repositories/program_repository.dart';
import '../repositories/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  StudentViewModel({StudentRepository? repository, ProgramRepository? programRepository})
      : _repo = repository ?? StudentRepository(),
        _programRepo = programRepository ?? ProgramRepository();

  final StudentRepository _repo;
  final ProgramRepository _programRepo;

  // ----- state -----
  List<Student> students = [];
  List<Program> programs = [];
  Student? selectedStudent;
  bool isLoading = false; // loading a list
  bool isSaving = false; // saving / deleting
  String? errorMessage;
  String searchQuery = '';

  /// List shown on screen (applies the search box).
  List<Student> get filteredStudents {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return students;
    return students
        .where((s) =>
            s.studentName.toLowerCase().contains(q) ||
            s.studentNumber.toLowerCase().contains(q))
        .toList();
  }

  void setSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void select(Student? student) {
    selectedStudent = student;
    notifyListeners();
  }

  // ----- actions -----
  Future<void> loadStudents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      students = await _repo.getAll();
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadPrograms() async {
    try {
      programs = await _programRepo.getAll();
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    notifyListeners();
  }

  Future<Student?> fetch(int id) async {
    try {
      return await _repo.getById(id);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
      notifyListeners();
      return null;
    }
  }

  /// Creates when `student.id == null`, otherwise updates.
  Future<bool> saveStudent(Student student) => _run(() async {
        if (student.id == null) {
          await _repo.create(student);
        } else {
          await _repo.update(student);
        }
      });

  Future<bool> deleteStudent(int id) => _run(() => _repo.delete(id));

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
