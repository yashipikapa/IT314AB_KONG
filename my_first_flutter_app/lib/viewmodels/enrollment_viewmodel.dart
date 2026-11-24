import 'package:flutter/foundation.dart';
import '../core/error_mapper.dart';
import '../models/enrollment.dart';
import '../models/schedule.dart';
import '../models/student.dart';
import '../models/subject.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/student_repository.dart';
import '../repositories/subject_repository.dart';

class EnrollmentViewModel extends ChangeNotifier {
  EnrollmentViewModel({
    EnrollmentRepository? repository,
    StudentRepository? studentRepository,
    SubjectRepository? subjectRepository,
    ScheduleRepository? scheduleRepository,
  })  : _repo = repository ?? EnrollmentRepository(),
        _studentRepo = studentRepository ?? StudentRepository(),
        _subjectRepo = subjectRepository ?? SubjectRepository(),
        _scheduleRepo = scheduleRepository ?? ScheduleRepository();

  final EnrollmentRepository _repo;
  final StudentRepository _studentRepo;
  final SubjectRepository _subjectRepo;
  final ScheduleRepository _scheduleRepo;

  // ----- state -----
  List<Student> students = [];
  List<Subject> subjects = [];
  List<Schedule> schedules = []; // schedules of the subject being chosen
  List<Enrollment> enrollments = []; // enrollments of the selected student
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;
  String? successMessage;

  // ----- loading -----
  Future<void> loadFormData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      students = await _studentRepo.getAll();
      subjects = await _subjectRepo.getAll();
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadForStudent(int? studentId) async {
    if (studentId == null) {
      enrollments = [];
      notifyListeners();
      return;
    }
    try {
      enrollments = await _repo.getByStudent(studentId);
      errorMessage = null;
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    notifyListeners();
  }

  Future<void> loadSchedulesForSubject(int? subjectId) async {
    if (subjectId == null) {
      schedules = [];
      notifyListeners();
      return;
    }
    try {
      schedules = await _scheduleRepo.getBySubject(subjectId);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    notifyListeners();
  }

  void clearSchedules() {
    schedules = [];
    notifyListeners();
  }

  Future<List<Schedule>> schedulesOfSubject(int subjectId) async {
    try {
      return await _scheduleRepo.getBySubject(subjectId);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
      notifyListeners();
      return [];
    }
  }

  // ----- the enrollment workflow -----
  /// 1 student -> 2 subject -> 3 schedule/slots -> 4 duplicate -> 5 conflict -> 6 save.
  Future<bool> enroll({
    required int? studentId,
    required int? subjectId,
    required int? scheduleId,
  }) async {
    successMessage = null;
    if (studentId == null) return _fail('Please select a student.');
    if (subjectId == null) return _fail('Please select a subject.');
    if (scheduleId == null) return _fail('Please select a schedule.');

    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      // Duplicate enrollment
      if (await _repo.isDuplicate(studentId, subjectId)) {
        return _fail('Enrollment rejected: the student is already enrolled in this subject.');
      }
      // Schedule exists + belongs to the chosen subject
      final schedule = await _scheduleRepo.getById(scheduleId);
      if (schedule == null || schedule.subjectId != subjectId) {
        return _fail('The selected schedule is not valid for this subject.');
      }
      // Remaining slots
      final taken = await _repo.countForSchedule(scheduleId);
      if (taken >= schedule.slotCapacity) {
        return _fail('Enrollment rejected: this schedule is already full.');
      }
      // Schedule conflict with the student's other subjects
      final conflict = await _repo.findConflict(studentId, scheduleId);
      if (conflict != null) {
        return _fail('Enrollment rejected: schedule conflict with $conflict.');
      }
      // All validations passed -> save
      await _repo.create(Enrollment(
        studentId: studentId,
        subjectId: subjectId,
        scheduleId: scheduleId,
      ));
      enrollments = await _repo.getByStudent(studentId);
      schedules = await _scheduleRepo.getBySubject(subjectId);
      successMessage = 'Student enrolled successfully!';
      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      return _fail(ErrorMapper.map(e));
    }
  }

  Future<bool> changeSchedule(Enrollment enrollment, int newScheduleId) async {
    successMessage = null;
    if (enrollment.id == null) return _fail('Invalid enrollment.');
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (newScheduleId == enrollment.scheduleId) {
        return _fail('That is already the current schedule.');
      }
      final schedule = await _scheduleRepo.getById(newScheduleId);
      if (schedule == null || schedule.subjectId != enrollment.subjectId) {
        return _fail('The selected schedule is not valid for this subject.');
      }
      final taken = await _repo.countForSchedule(newScheduleId);
      if (taken >= schedule.slotCapacity) {
        return _fail('Change rejected: this schedule is already full.');
      }
      final conflict = await _repo.findConflict(
        enrollment.studentId,
        newScheduleId,
        excludeEnrollmentId: enrollment.id!,
      );
      if (conflict != null) {
        return _fail('Change rejected: schedule conflict with $conflict.');
      }
      await _repo.updateSchedule(enrollment.id!, newScheduleId);
      enrollments = await _repo.getByStudent(enrollment.studentId);
      successMessage = 'Schedule changed.';
      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      return _fail(ErrorMapper.map(e));
    }
  }

  Future<bool> drop(Enrollment enrollment) async {
    successMessage = null;
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repo.delete(enrollment.id!);
      enrollments = await _repo.getByStudent(enrollment.studentId);
      successMessage = 'Subject dropped.';
      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      return _fail(ErrorMapper.map(e));
    }
  }

  bool _fail(String message) {
    errorMessage = message;
    successMessage = null;
    isSaving = false;
    notifyListeners();
    return false;
  }
}
