import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  // Times are cast to text so we always receive 'HH:mm:ss' strings.
  static const String _select = '''
    SELECT sc.schedule_id, sc.subject_id, sc.day_of_week,
           sc.start_time::text AS start_time, sc.end_time::text AS end_time,
           sc.room, sc.slot_capacity, su.subject_code, su.subject_name,
           (SELECT COUNT(*) FROM enrollment e WHERE e.schedule_id = sc.schedule_id)::int AS enrolled_count
    FROM schedule sc
    JOIN subject su ON su.subject_id = sc.subject_id
  ''';

  static const String _order = '''
    ORDER BY su.subject_code,
      CASE sc.day_of_week
        WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7 ELSE 8 END,
      sc.start_time
  ''';

  Future<List<Schedule>> getAll() async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(Sql.named('$_select $_order'));
    return result.map((r) => Schedule.fromRow(r.toColumnMap())).toList();
  }

  Future<List<Schedule>> getBySubject(int subjectId) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('$_select WHERE sc.subject_id = @subject_id $_order'),
      parameters: {'subject_id': subjectId},
    );
    return result.map((r) => Schedule.fromRow(r.toColumnMap())).toList();
  }

  Future<Schedule?> getById(int id) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('$_select WHERE sc.schedule_id = @id'),
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    return Schedule.fromRow(result.first.toColumnMap());
  }

  Future<int> create(Schedule s) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO schedule (subject_id, day_of_week, start_time, end_time, room, slot_capacity)
        VALUES (@subject_id, @day_of_week, @start_time::text::time, @end_time::text::time, @room, @slot_capacity)
        RETURNING schedule_id
      '''),
      parameters: s.toMap(),
    );
    return result.first[0] as int;
  }

  Future<void> update(Schedule s) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('''
        UPDATE schedule
        SET subject_id = @subject_id, day_of_week = @day_of_week,
            start_time = @start_time::text::time, end_time = @end_time::text::time,
            room = @room, slot_capacity = @slot_capacity
        WHERE schedule_id = @id
      '''),
      parameters: {...s.toMap(), 'id': s.id},
    );
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('DELETE FROM schedule WHERE schedule_id = @id'),
      parameters: {'id': id},
    );
  }
}
