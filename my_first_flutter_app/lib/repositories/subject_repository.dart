import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/subject.dart';

class SubjectRepository {
  static const String _select = '''
    SELECT s.subject_id, s.subject_code, s.subject_name, s.units, s.description,
           (SELECT COUNT(*) FROM schedule sc WHERE sc.subject_id = s.subject_id)::int AS schedule_count
    FROM subject s
  ''';

  Future<List<Subject>> getAll() async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(Sql.named('$_select ORDER BY s.subject_code'));
    return result.map((r) => Subject.fromRow(r.toColumnMap())).toList();
  }

  Future<int> create(Subject s) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO subject (subject_code, subject_name, units, description)
        VALUES (@subject_code, @subject_name, @units, @description)
        RETURNING subject_id
      '''),
      parameters: s.toMap(),
    );
    return result.first[0] as int;
  }

  Future<void> update(Subject s) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('''
        UPDATE subject
        SET subject_code = @subject_code, subject_name = @subject_name,
            units = @units, description = @description
        WHERE subject_id = @id
      '''),
      parameters: {...s.toMap(), 'id': s.id},
    );
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('DELETE FROM subject WHERE subject_id = @id'),
      parameters: {'id': id},
    );
  }
}
