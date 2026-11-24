import 'package:flutter/material.dart';
import '../../models/grade.dart';
import '../../models/student.dart';
import '../../viewmodels/enrollment_viewmodel.dart';
import '../../viewmodels/grade_viewmodel.dart';
import '../../viewmodels/student_viewmodel.dart';
import 'enrollment_screen.dart';
import 'grade_screen.dart';
import 'student_form_screen.dart';

Future<bool> _confirm(BuildContext context, String title, String message) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
      ],
    ),
  );
  return result ?? false;
}

// =====================================================================
// STUDENT LIST  (Read all / Delete / go to Create & Details)
// =====================================================================
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _vm = StudentViewModel();

  @override
  void initState() {
    super.initState();
    _vm.loadStudents();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  Future<void> _openForm() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const StudentFormScreen()),
    );
    if (saved == true) _vm.loadStudents();
  }

  Future<void> _openDetails(Student s) async {
    _vm.select(s);
    await Navigator.push(context, MaterialPageRoute(builder: (_) => StudentDetailsScreen(student: s)));
    _vm.loadStudents(); // the student may have been edited or deleted
  }

  Future<void> _delete(Student s) async {
    final yes = await _confirm(context, 'Delete student', 'Delete ${s.studentName}? This cannot be undone.');
    if (!yes) return;
    final ok = await _vm.deleteStudent(s.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Student deleted.' : (_vm.errorMessage ?? 'Delete failed.'))),
    );
    if (ok) _vm.loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openForm,
        child: const Icon(Icons.person_add),
      ),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          // --- conditional widgets: loading / error / empty / data ---
          Widget body;
          final list = _vm.filteredStudents;
          if (_vm.isLoading) {
            body = const Center(child: CircularProgressIndicator());
          } else if (_vm.errorMessage != null && _vm.students.isEmpty) {
            body = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_vm.errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton(onPressed: _vm.loadStudents, child: const Text('Retry')),
                ],
              ),
            );
          } else if (list.isEmpty) {
            body = const Center(child: Text('No students found.'));
          } else {
            body = RefreshIndicator(
              onRefresh: _vm.loadStudents,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final s = list[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(s.studentName.isEmpty ? '?' : s.studentName[0].toUpperCase())),
                      title: Text(s.studentName),
                      subtitle: Text('${s.studentNumber} • ${s.programName ?? 'No program'} • Year ${s.yearLevel}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(s),
                      ),
                      onTap: () => _openDetails(s),
                    ),
                  );
                },
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: _vm.setSearch,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search by name or student number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          );
        },
      ),
    );
  }
}

// =====================================================================
// STUDENT DETAILS  (Read one + enrolled subjects + grades, Edit, Delete)
// =====================================================================
class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final _studentVm = StudentViewModel();
  final _enrollVm = EnrollmentViewModel();
  final _gradeVm = GradeViewModel();
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.student;
    _reload();
  }

  @override
  void dispose() {
    _studentVm.dispose();
    _enrollVm.dispose();
    _gradeVm.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final id = _student.id!;
    final fresh = await _studentVm.fetch(id);
    if (fresh != null && mounted) setState(() => _student = fresh);
    await _enrollVm.loadForStudent(id);
    await _gradeVm.loadGrades(studentId: id);
  }

  Future<void> _edit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => StudentFormScreen(student: _student)),
    );
    if (saved == true) _reload();
  }

  Future<void> _delete() async {
    final yes = await _confirm(context, 'Delete student', 'Delete ${_student.studentName}? This cannot be undone.');
    if (!yes) return;
    final ok = await _studentVm.deleteStudent(_student.id!);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student deleted.')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_studentVm.errorMessage ?? 'Delete failed.')));
    }
  }

  Future<void> _go(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _edit),
          IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([_enrollVm, _gradeVm]),
        builder: (context, _) {
          final enrollments = _enrollVm.enrollments;
          // map enrollment_id -> grade so each subject can show its grade
          final gradeByEnrollment = <int, Grade>{for (final g in _gradeVm.grades) g.enrollmentId: g};

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: enrollments.length + 1, // index 0 = header
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_student.studentName, style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            Text('Student No.: ${_student.studentNumber}'),
                            Text('Email: ${_student.email}'),
                            Text('Program: ${_student.programName ?? '-'}'),
                            Text('Year Level: ${_student.yearLevel}'),
                            Text('Contact: ${_student.contactNumber}'),
                          ],
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: () => _go(EnrollmentScreen(student: _student)),
                          icon: const Icon(Icons.how_to_reg),
                          label: const Text('Enroll / Manage'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _go(GradeScreen(student: _student)),
                          icon: const Icon(Icons.grade),
                          label: const Text('Grades'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Enrolled Subjects', style: Theme.of(context).textTheme.titleMedium),
                    if (enrollments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Not enrolled in any subject yet.'),
                      ),
                  ],
                );
              }
              final e = enrollments[index - 1];
              final g = gradeByEnrollment[e.id];
              return Card(
                child: ListTile(
                  title: Text('${e.subjectCode} - ${e.subjectName}'),
                  subtitle: Text('${e.scheduleLabel}\nStatus: ${e.status}'),
                  isThreeLine: true,
                  trailing: g == null
                      ? const Chip(label: Text('No grade'))
                      : Chip(label: Text('${g.score.toStringAsFixed(2)} • ${g.remarks}')),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
