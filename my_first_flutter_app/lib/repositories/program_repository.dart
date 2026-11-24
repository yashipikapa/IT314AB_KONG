import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/program.dart';

class ProgramRepository {
  Future<List<Program>> getAll() async {
    final conn = await DbConnection.instance.connection;
    final result = await conn.execute(
      Sql.named('SELECT program_id, program_code, program_name FROM program ORDER BY program_name'),
    );
    return result.map((r) => Program.fromRow(r.toColumnMap())).toList();
  }
}
