import 'package:flutter/material.dart';
import '../../models/enrollment.dart';
import '../../models/schedule.dart';
import '../../models/student.dart';
import '../../viewmodels/enrollment_viewmodel.dart';

/// Enrollment workflow: select student -> subject -> schedule -> Enroll.
/// Also lists the student's enrolled subjects (change schedule / drop).
class EnrollmentScreen extends StatefulWidget {
  final Student? student; // when opened from Student Details
  const EnrollmentScreen({super.key, this.student});

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  final _vm = EnrollmentViewModel();
  int? _studentId;
  int? _subjectId;
  int? _scheduleId;

  @override
  void initState() {
    super.initState();
    _studentId = widget.student?.id;
    _init();
  }

  Future<void> _init() async {
    await _vm.loadFormData();
    await _vm.loadForStudent(_studentId);
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _enroll() async {
    final ok = await _vm.enroll(studentId: _studentId, subjectId: _subjectId, scheduleId: _scheduleId);
    if (!mounted) return;
    _snack(ok ? (_vm.successMessage ?? 'Enrolled.') : (_vm.errorMessage ?? 'Enrollment failed.'));
    if (ok) setState(() => _scheduleId = null);
  }

  Future<void> _changeSchedule(Enrollment e) async {
    final options = await _vm.schedulesOfSubject(e.subjectId);
    if (!mounted) return;
    final picked = await showDialog<Schedule>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('New schedule for ${e.subjectCode}'),
        children: [
          if (options.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('No schedules available.')),
          for (final sc in options)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, sc),
              child: Text('${sc.label}  (${sc.slotsLeft} left)'),
            ),
        ],
      ),
    );
    if (picked == null) return;
    final ok = await _vm.changeSchedule(e, picked.id!);
    if (!mounted) return;
    _snack(ok ? (_vm.successMessage ?? 'Updated.') : (_vm.errorMessage ?? 'Failed.'));
  }

  Future<void> _drop(Enrollment e) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Drop subject'),
        content: Text('Drop ${e.subjectCode} - ${e.subjectName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Drop')),
        ],
      ),
    );
    if (yes != true) return;
    final ok = await _vm.drop(e);
    if (!mounted) return;
    _snack(ok ? (_vm.successMessage ?? 'Dropped.') : (_vm.errorMessage ?? 'Failed.'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enrollment')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          if (_vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (_vm.students.isEmpty && _vm.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_vm.errorMessage!),
                  FilledButton(onPressed: _init, child: const Text('Retry')),
                ],
              ),
            );
          }

          final scheduleValid = _vm.schedules.any((s) => s.id == _scheduleId);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Enrollment', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      // 1. student
                      DropdownButtonFormField<int>(
                        value: _vm.students.any((s) => s.id == _studentId) ? _studentId : null,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: '1. Student', border: OutlineInputBorder()),
                        items: [
                          for (final s in _vm.students)
                            DropdownMenuItem(value: s.id!, child: Text('${s.studentNumber} - ${s.studentName}', overflow: TextOverflow.ellipsis)),
                        ],
                        onChanged: (v) {
                          setState(() => _studentId = v);
                          _vm.loadForStudent(v);
                        },
                      ),
                      const SizedBox(height: 12),
                      // 2. subject
                      DropdownButtonFormField<int>(
                        value: _vm.subjects.any((s) => s.id == _subjectId) ? _subjectId : null,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: '2. Subject', border: OutlineInputBorder()),
                        items: [
                          for (final s in _vm.subjects)
                            DropdownMenuItem(value: s.id!, child: Text('${s.subjectCode} - ${s.subjectName}', overflow: TextOverflow.ellipsis)),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _subjectId = v;
                            _scheduleId = null;
                          });
                          _vm.loadSchedulesForSubject(v);
                        },
                      ),
                      const SizedBox(height: 12),
                      // 3. schedule (shows remaining slots; full schedules are disabled)
                      if (_subjectId != null && _vm.schedules.isEmpty)
                        const Text('This subject has no schedules yet.')
                      else
                        DropdownButtonFormField<int>(
                          value: scheduleValid ? _scheduleId : null,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: '3. Schedule', border: OutlineInputBorder()),
                          items: [
                            for (final sc in _vm.schedules)
                              DropdownMenuItem(
                                value: sc.id!,
                                enabled: sc.slotsLeft > 0,
                                child: Text(
                                  '${sc.label} • ${sc.slotsLeft > 0 ? '${sc.slotsLeft} left' : 'FULL'}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: (v) => setState(() => _scheduleId = v),
                        ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _vm.isSaving ? null : _enroll,
                        icon: _vm.isSaving
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.how_to_reg),
                        label: const Text('Enroll'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('Enrolled Subjects', style: Theme.of(context).textTheme.titleMedium),
              if (_studentId == null)
                const Padding(padding: EdgeInsets.all(12), child: Text('Select a student to see their subjects.'))
              else if (_vm.enrollments.isEmpty)
                const Padding(padding: EdgeInsets.all(12), child: Text('This student has no enrollments yet.'))
              else
                for (final e in _vm.enrollments)
                  Card(
                    child: ListTile(
                      title: Text('${e.subjectCode} - ${e.subjectName}'),
                      subtitle: Text('${e.scheduleLabel}\nStatus: ${e.status}'),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) => v == 'change' ? _changeSchedule(e) : _drop(e),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'change', child: Text('Change schedule')),
                          PopupMenuItem(value: 'drop', child: Text('Drop subject')),
                        ],
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
