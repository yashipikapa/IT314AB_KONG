import 'package:flutter/foundation.dart';
import '../core/error_mapper.dart';
import '../models/enrollment.dart';
import '../models/grade.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/grade_repository.dart';

class GradeViewModel extends ChangeNotifier {
  GradeViewModel({GradeRepository? repository, EnrollmentRepository? enrollmentRepository})
      : _repo = repository ?? GradeRepository(),
        _enrollmentRepo = enrollmentRepository ?? EnrollmentRepository();

  final GradeRepository _repo;
  final EnrollmentRepository _enrollmentRepo;

  List<Grade> grades = [];
  List<Enrollment> enrollments = []; // enrollments that can receive a grade
  Grade? selectedGrade;
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  void select(Grade? grade) {
    selectedGrade = grade;
    notifyListeners();
  }

  /// `studentId == null` loads every grade, otherwise only that student's.
  Future<void> loadGrades({int? studentId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      grades = studentId == null
          ? await _repo.getAll()
          : await _repo.getByStudent(studentId);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadEnrollments({int? studentId}) async {
    try {
      enrollments = studentId == null
          ? await _enrollmentRepo.getAll()
          : await _enrollmentRepo.getByStudent(studentId);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    notifyListeners();
  }

  /// Creates when `grade.id == null`, otherwise updates.
  Future<bool> saveGrade(Grade grade, {int? reloadStudentId}) async {
    if (grade.score < 0 || grade.score > 100) {
      errorMessage = 'Score must be between 0 and 100.';
      notifyListeners();
      return false;
    }
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    var ok = true;
    try {
      // Rule: an enrollment must exist before a grade can be assigned.
      if (!await _enrollmentRepo.exists(grade.enrollmentId)) {
        throw 'An enrollment must exist before assigning a grade.';
      }
      // If remarks are blank we fill them in automatically.
      final remarks = grade.remarks.trim().isEmpty
          ? (grade.score >= 75 ? 'Passed' : 'Failed')
          : grade.remarks.trim();
      final toSave = Grade(
        id: grade.id,
        enrollmentId: grade.enrollmentId,
        score: grade.score,
        remarks: remarks,
      );
      if (toSave.id == null) {
        await _repo.create(toSave);
      } else {
        await _repo.update(toSave);
      }
      grades = reloadStudentId == null
          ? await _repo.getAll()
          : await _repo.getByStudent(reloadStudentId);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
      ok = false;
    }
    isSaving = false;
    notifyListeners();
    return ok;
  }

  Future<bool> deleteGrade(int id, {int? reloadStudentId}) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    var ok = true;
    try {
      await _repo.delete(id);
      grades = reloadStudentId == null
          ? await _repo.getAll()
          : await _repo.getByStudent(reloadStudentId);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
      ok = false;
    }
    isSaving = false;
    notifyListeners();
    return ok;
  }
}
