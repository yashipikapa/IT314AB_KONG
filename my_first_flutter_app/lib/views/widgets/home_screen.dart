import 'package:flutter/material.dart';
import '../../core/db_connection.dart';
import '../../core/error_mapper.dart';
import 'enrollment_screen.dart';
import 'grade_screen.dart';
import 'schedule_screen.dart';
import 'student_list_screen.dart';
import 'subject_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _checking = true; // true while the test query is running
  String? _error; // null + !_checking  => connected

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      await DbConnection.instance.testConnection();
    } catch (e) {
      debugPrint('DB ERROR: $e');
      debugPrint('HOST="${const String.fromEnvironment('DB_HOST')}"');
      _error = ErrorMapper.map(e);
    }
    if (!mounted) return;
    setState(() => _checking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _error == null
              ? 'Connected to the database.'
              : 'Connection failed: $_error',
        ),
      ),
    );
  }

  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final connected = !_checking && _error == null;
    final menu = <_MenuItem>[
      _MenuItem(
        'Students',
        Icons.people,
        () => _open(const StudentListScreen()),
      ),
      _MenuItem(
        'Subjects',
        Icons.menu_book,
        () => _open(const SubjectScreen()),
      ),
      _MenuItem(
        'Schedules',
        Icons.schedule,
        () => _open(const ScheduleScreen()),
      ),
      _MenuItem(
        'Enrollment',
        Icons.how_to_reg,
        () => _open(const EnrollmentScreen()),
      ),
      _MenuItem('Grades', Icons.grade, () => _open(const GradeScreen())),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Enrollment System')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Conditional widget: checking / failed / connected
            Card(
              color: _checking
                  ? Colors.blueGrey.shade50
                  : (connected ? Colors.green.shade50 : Colors.red.shade50),
              child: ListTile(
                leading: _checking
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        connected ? Icons.check_circle : Icons.error,
                        color: connected ? Colors.green : Colors.red,
                      ),
                title: Text(
                  _checking
                      ? 'Connecting to Neon...'
                      : (connected
                            ? 'Database connected'
                            : 'Database connection failed'),
                ),
                subtitle: _error == null ? null : Text(_error!),
                trailing: (_checking || connected)
                    ? null
                    : TextButton(
                        onPressed: _connect,
                        child: const Text('Retry'),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  for (final item in menu)
                    Card(
                      child: InkWell(
                        onTap: connected ? item.onTap : null,
                        child: Opacity(
                          opacity: connected ? 1 : 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 44),
                              const SizedBox(height: 8),
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _MenuItem(this.title, this.icon, this.onTap);
}
