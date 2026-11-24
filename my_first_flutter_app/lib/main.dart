import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/db_connection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load database configuration
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neon Database Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const DatabaseTestScreen(),
    );
  }
}

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() =>
      _DatabaseTestScreenState();
}

class _DatabaseTestScreenState
    extends State<DatabaseTestScreen> {
  bool isLoading = false;
  String connectionStatus = 'Not connected';

  Future<void> testDatabase() async {
    setState(() {
      isLoading = true;
      connectionStatus = 'Connecting to Neon...';
    });

    try {
      await DbConnection.instance.testConnection();

      setState(() {
        connectionStatus = 'Successfully connected to Neon!';
      });
    } catch (e) {
      setState(() {
        connectionStatus = 'Connection failed:\n$e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neon Database Connection'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storage,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              Text(
                connectionStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: isLoading ? null : testDatabase,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Test Database Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 