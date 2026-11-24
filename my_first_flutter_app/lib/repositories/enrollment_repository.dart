import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/enrollment.dart';

class EnrollmentRepository {
  static const String _select = '''
    SELECT e.enrollment_id, e.student_id, e.subject_id, e.schedule_id, e.enrolled_at, e.status,
           st.student_name, su.subject_code, su.subject_name,
           sc.day_of_week, sc.start_time::text AS start_time, sc.end_time::text AS end_time, sc.room
    FROM enrollment e
    JOIN students st ON st.student_id = e.student_id
    JOIN subject su ON su.subject_id = e.subject_id
    LEFT JOIN schedule sc ON sc.schedule_id = e.schedule_id
  ''';

  Future<List<Enrollment>> getAll() async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('$_select ORDER BY st.student_name, su.subject_code'),
    );
    return result.map((r) => Enrollment.fromRow(r.toColumnMap())).toList();
  }

  Future<List<Enrollment>> getByStudent(int studentId) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('$_select WHERE e.student_id = @student_id ORDER BY su.subject_code'),
      parameters: {'student_id': studentId},
    );
    return result.map((r) => Enrollment.fromRow(r.toColumnMap())).toList();
  }

  Future<bool> exists(int enrollmentId) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('SELECT 1 FROM enrollment WHERE enrollment_id = @id'),
      parameters: {'id': enrollmentId},
    );
    return result.isNotEmpty;
  }

  /// Rule: a student cannot enroll in the same subject twice.
  Future<bool> isDuplicate(int studentId, int subjectId) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('SELECT 1 FROM enrollment WHERE student_id = @student_id AND subject_id = @subject_id'),
      parameters: {'student_id': studentId, 'subject_id': subjectId},
    );
    return result.isNotEmpty;
  }

  /// How many students already took a slot in this schedule.
  Future<int> countForSchedule(int scheduleId) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('SELECT COUNT(*)::int FROM enrollment WHERE schedule_id = @schedule_id'),
      parameters: {'schedule_id': scheduleId},
    );
    return result.first[0] as int;
  }

  /// Rule: schedule conflicts must be prevented.
  /// Returns the conflicting subject (e.g. "IT101 - Programming") or null.
  /// Two schedules overlap when: same day AND start < otherEnd AND end > otherStart.
  Future<String?> findConflict(int studentId, int scheduleId, {int excludeEnrollmentId = 0}) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('''
        SELECT su.subject_code || ' - ' || su.subject_name
        FROM enrollment e
        JOIN schedule old_sc ON old_sc.schedule_id = e.schedule_id
        JOIN subject su ON su.subject_id = e.subject_id
        JOIN schedule new_sc ON new_sc.schedule_id = @schedule_id
        WHERE e.student_id = @student_id
          AND e.enrollment_id <> @exclude_id
          AND old_sc.day_of_week = new_sc.day_of_week
          AND old_sc.start_time < new_sc.end_time
          AND old_sc.end_time > new_sc.start_time
        LIMIT 1
      '''),
      parameters: {
        'schedule_id': scheduleId,
        'student_id': studentId,
        'exclude_id': excludeEnrollmentId,
      },
    );
    if (result.isEmpty) return null;
    return result.first[0] as String;
  }

  Future<int> create(Enrollment e) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO enrollment (student_id, subject_id, schedule_id, enrolled_at, status)
        VALUES (@student_id, @subject_id, @schedule_id, NOW(), @status)
        RETURNING enrollment_id
      '''),
      parameters: e.toMap(),
    );
    return result.first[0] as int;
  }

  Future<void> updateSchedule(int enrollmentId, int scheduleId) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('UPDATE enrollment SET schedule_id = @schedule_id WHERE enrollment_id = @id'),
      parameters: {'schedule_id': scheduleId, 'id': enrollmentId},
    );
  }

  Future<void> delete(int enrollmentId) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('DELETE FROM enrollment WHERE enrollment_id = @id'),
      parameters: {'id': enrollmentId},
    );
  }
}
