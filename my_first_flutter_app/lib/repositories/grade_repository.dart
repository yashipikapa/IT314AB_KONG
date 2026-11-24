import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/grade.dart';

class GradeRepository {
  static const String _select = '''
    SELECT g.grade_id, g.enrollment_id, g.score::float8 AS score, g.remarks,
           g.date_recorded::text AS date_recorded,
           e.student_id, st.student_name, su.subject_code, su.subject_name
    FROM grades g
    JOIN enrollment e ON e.enrollment_id = g.enrollment_id
    JOIN students st ON st.student_id = e.student_id
    JOIN subject su ON su.subject_id = e.subject_id
  ''';

  Future<List<Grade>> getAll() async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('$_select ORDER BY st.student_name, su.subject_code'),
    );
    return result.map((r) => Grade.fromRow(r.toColumnMap())).toList();
  }

  Future<List<Grade>> getByStudent(int studentId) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('$_select WHERE e.student_id = @student_id ORDER BY su.subject_code'),
      parameters: {'student_id': studentId},
    );
    return result.map((r) => Grade.fromRow(r.toColumnMap())).toList();
  }

  Future<int> create(Grade g) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO grades (enrollment_id, score, remarks, date_recorded)
        VALUES (@enrollment_id, @score::float8, @remarks, CURRENT_DATE)
        RETURNING grade_id
      '''),
      parameters: g.toMap(),
    );
    return result.first[0] as int;
  }

  Future<void> update(Grade g) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('''
        UPDATE grades
        SET score = @score::float8, remarks = @remarks, date_recorded = CURRENT_DATE
        WHERE grade_id = @id
      '''),
      parameters: {'score': g.score, 'remarks': g.remarks, 'id': g.id},
    );
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('DELETE FROM grades WHERE grade_id = @id'),
      parameters: {'id': id},
    );
  }
}
