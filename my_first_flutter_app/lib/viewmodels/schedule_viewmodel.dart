import 'package:flutter/foundation.dart';
import '../core/error_mapper.dart';
import '../models/schedule.dart';
import '../models/subject.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/subject_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  ScheduleViewModel({ScheduleRepository? repository, SubjectRepository? subjectRepository})
      : _repo = repository ?? ScheduleRepository(),
        _subjectRepo = subjectRepository ?? SubjectRepository();

  final ScheduleRepository _repo;
  final SubjectRepository _subjectRepo;

  List<Schedule> schedules = [];
  List<Subject> subjects = []; // for the subject dropdown in the form
  Schedule? selectedSchedule;
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;

  /// `subjectId == null` loads every schedule, otherwise only that subject's.
  Future<void> loadSchedules({int? subjectId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      schedules = subjectId == null
          ? await _repo.getAll()
          : await _repo.getBySubject(subjectId);
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadSubjects() async {
    try {
      subjects = await _subjectRepo.getAll();
    } catch (e) {
      errorMessage = ErrorMapper.map(e);
    }
    notifyListeners();
  }

  void select(Schedule? schedule) {
    selectedSchedule = schedule;
    notifyListeners();
  }

  Future<bool> saveSchedule(Schedule schedule, {int? reloadSubjectId}) async {
    // Validation before touching the database
    if (schedule.endTime.compareTo(schedule.startTime) <= 0) {
      errorMessage = 'End time must be later than start time.';
      notifyListeners();
      return false;
    }
    if (schedule.slotCapacity <= 0) {
      errorMessage = 'Slot capacity must be at least 1.';
      notifyListeners();
      return false;
    }
    return _run(() async {
      if (schedule.id == null) {
        await _repo.create(schedule);
      } else {
        final taken = schedule.enrolledCount ?? 0;
        if (schedule.slotCapacity < taken) {
          throw 'Capacity cannot be lower than the $taken student(s) already enrolled.';
        }
        await _repo.update(schedule);
      }
      await _reload(reloadSubjectId);
    });
  }

  Future<bool> deleteSchedule(int id, {int? reloadSubjectId}) => _run(() async {
        await _repo.delete(id);
        await _reload(reloadSubjectId);
      });

  Future<void> _reload(int? subjectId) async {
    schedules = subjectId == null
        ? await _repo.getAll()
        : await _repo.getBySubject(subjectId);
  }

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
