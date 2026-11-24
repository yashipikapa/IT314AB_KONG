import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/student.dart';

class StudentRepository {
  // Constant SQL fragment (no user input inside).
  static const String _select = '''
    SELECT s.student_id, s.student_number, s.student_name, s.email, s.program_id,
           s.year_level, s.contact_number, s.created_at, p.program_name
    FROM students s
    LEFT JOIN program p ON p.program_id = s.program_id
  ''';

  Future<List<Student>> getAll() async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(Sql.named('$_select ORDER BY s.student_name'));
    return result.map((r) => Student.fromRow(r.toColumnMap())).toList();
  }

  Future<Student?> getById(int id) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('$_select WHERE s.student_id = @id'),
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    return Student.fromRow(result.first.toColumnMap());
  }

  Future<int> create(Student s) async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO students (student_number, student_name, email, program_id, year_level, contact_number, created_at)
        VALUES (@student_number, @student_name, @email, @program_id, @year_level, @contact_number, NOW())
        RETURNING student_id
      '''),
      parameters: s.toMap(),
    );
    return result.first[0] as int;
  }

  Future<void> update(Student s) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('''
        UPDATE students
        SET student_number = @student_number, student_name = @student_name, email = @email,
            program_id = @program_id, year_level = @year_level, contact_number = @contact_number
        WHERE student_id = @id
      '''),
      parameters: {...s.toMap(), 'id': s.id},
    );
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.instance.connection;
    await conn.execute(
      Sql.named('DELETE FROM students WHERE student_id = @id'),
      parameters: {'id': id},
    );
  }
}
