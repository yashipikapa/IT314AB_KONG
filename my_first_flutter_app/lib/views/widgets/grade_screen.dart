import 'package:flutter/material.dart';
import '../../models/enrollment.dart';
import '../../models/grade.dart';
import '../../models/student.dart';
import '../../viewmodels/grade_viewmodel.dart';

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

/// Shows every grade, or only the grades of [student] when it is given.
class GradeScreen extends StatefulWidget {
  final Student? student;
  const GradeScreen({super.key, this.student});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  final _vm = GradeViewModel();

  @override
  void initState() {
    super.initState();
    _vm.loadGrades(studentId: widget.student?.id);
    _vm.loadEnrollments(studentId: widget.student?.id);
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _openForm([Grade? grade]) async {
    await _vm.loadEnrollments(studentId: widget.student?.id); // refresh choices
    if (!mounted) return;
    if (grade == null && _vm.enrollments.isEmpty) {
      _snack('No enrollments yet. Enroll a student in a subject before adding a grade.');
      return;
    }
    final result = await showDialog<Grade>(
      context: context,
      builder: (_) => _GradeFormDialog(grade: grade, enrollments: _vm.enrollments),
    );
    if (result == null) return;
    final ok = await _vm.saveGrade(result, reloadStudentId: widget.student?.id);
    if (!mounted) return;
    _snack(ok ? (grade == null ? 'Grade added.' : 'Grade updated.') : (_vm.errorMessage ?? 'Failed.'));
  }

  Future<void> _delete(Grade g) async {
    final yes = await _confirm(context, 'Delete grade', 'Delete the grade for ${g.studentName} in ${g.subjectCode}?');
    if (!yes) return;
    final ok = await _vm.deleteGrade(g.id!, reloadStudentId: widget.student?.id);
    if (!mounted) return;
    _snack(ok ? 'Grade deleted.' : (_vm.errorMessage ?? 'Failed.'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Grades' : '${widget.student!.studentName} - Grades'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          if (_vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (_vm.errorMessage != null && _vm.grades.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_vm.errorMessage!),
                  FilledButton(
                    onPressed: () => _vm.loadGrades(studentId: widget.student?.id),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (_vm.grades.isEmpty) return const Center(child: Text('No grades recorded yet.'));
          return ListView.builder(
            itemCount: _vm.grades.length,
            itemBuilder: (context, index) {
              final g = _vm.grades[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text('${g.subjectCode} - ${g.subjectName}'),
                  subtitle: Text('${g.studentName}\nScore: ${g.score.toStringAsFixed(2)} • ${g.remarks}\nRecorded: ${g.dateRecorded ?? '-'}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(g)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(g)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _GradeFormDialog extends StatefulWidget {
  final Grade? grade;
  final List<Enrollment> enrollments;
  const _GradeFormDialog({this.grade, required this.enrollments});

  @override
  State<_GradeFormDialog> createState() => _GradeFormDialogState();
}

class _GradeFormDialogState extends State<_GradeFormDialog> {
  final _key = GlobalKey<FormState>();
  late final _score = TextEditingController(text: widget.grade?.score.toStringAsFixed(2));
  late final _remarks = TextEditingController(text: widget.grade?.remarks);
  int? _enrollmentId;

  @override
  void initState() {
    super.initState();
    _enrollmentId = widget.grade?.enrollmentId;
  }

  @override
  void dispose() {
    _score.dispose();
    _remarks.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.pop(
      context,
      Grade(
        id: widget.grade?.id,
        enrollmentId: _enrollmentId!,
        score: double.parse(_score.text.trim()),
        remarks: _remarks.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.grade != null;
    final valid = widget.enrollments.any((e) => e.id == _enrollmentId);
    return AlertDialog(
      title: Text(isEdit ? 'Edit Grade' : 'Add Grade'),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: valid ? _enrollmentId : null,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Enrollment (student - subject)'),
                items: [
                  for (final e in widget.enrollments)
                    DropdownMenuItem(
                      value: e.id!,
                      child: Text('${e.studentName} - ${e.subjectCode}', overflow: TextOverflow.ellipsis),
                    ),
                ],
                // The enrollment of an existing grade cannot be changed.
                onChanged: isEdit ? null : (v) => setState(() => _enrollmentId = v),
                validator: (v) => (isEdit || v != null) ? null : 'Select an enrollment',
              ),
              TextFormField(
                controller: _score,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Score (0 - 100)'),
                validator: (v) {
                  final n = double.tryParse(v?.trim() ?? '');
                  if (n == null) return 'Enter a number';
                  if (n < 0 || n > 100) return 'Score must be between 0 and 100';
                  return null;
                },
              ),
              TextFormField(
                controller: _remarks,
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  helperText: 'Leave blank to auto-fill Passed / Failed',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
