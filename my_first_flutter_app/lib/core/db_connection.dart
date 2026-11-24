import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbConnection {
  DbConnection._();

  static final DbConnection instance = DbConnection._();

  Connection? _connection;

  Future<Connection> get connection async {
    final existing = _connection;

    if (existing != null && existing.isOpen) {
      return existing;
    }

    final host = dotenv.env['DB_HOST'] ?? '';
    final port = int.parse(dotenv.env['DB_PORT'] ?? '5432');
    final database = dotenv.env['DB_NAME'] ?? '';
    final username = dotenv.env['DB_USER'] ?? '';
    final password = dotenv.env['DB_PASSWORD'] ?? '';

    if (host.isEmpty ||
        database.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      throw Exception('Missing Neon database configuration in .env');
    }

    _connection = await Connection.open(
      Endpoint(
        host: host,
        port: port,
        database: database,
        username: username,
        password: password,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
        connectTimeout: Duration(seconds: 30),
      ),
    );

    return _connection!;
  }

  Future<void> testConnection() async {
    final conn = await connection;
    await conn.execute('SELECT 1');
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }
}
