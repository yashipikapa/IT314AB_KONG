import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbConnection {
  DbConnection._();
  static final DbConnection instance = DbConnection._();

  static const String _host = String.fromEnvironment('DB_HOST');
  static const int _port = int.fromEnvironment('DB_PORT', defaultValue: 5432);
  static const String _database = String.fromEnvironment('DB_NAME');
  static const String _username = String.fromEnvironment('DB_USER');
  static const String _password = String.fromEnvironment('DB_PASSWORD');

  Connection? _connection;

  Future<Connection> get connection async {
    final existing = _connection;
    if (existing != null && existing.isOpen) return existing;

    _connection = await Connection.open(
      Endpoint(
        host: _host,
        port: _port,
        database: _database,
        username: _username,
        password: _password,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require, // SSL is mandatory for Neon
        connectTimeout: Duration(seconds: 30), // Neon may need to wake up
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