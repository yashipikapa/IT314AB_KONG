import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../../viewmodels/subject_viewmodel.dart';
import 'schedule_screen.dart';

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
// SUBJECT LIST  (Create / Read / Update / Delete)
// =====================================================================
class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final _vm = SubjectViewModel();

  @override
  void initState() {
    super.initState();
    _vm.loadSubjects();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _openForm([Subject? subject]) async {
    final result = await showDialog<Subject>(
      context: context,
      builder: (_) => _SubjectFormDialog(subject: subject),
    );
    if (result == null) return;
    final ok = await _vm.saveSubject(result);
    if (!mounted) return;
    _snack(ok ? (subject == null ? 'Subject added.' : 'Subject updated.') : (_vm.errorMessage ?? 'Failed.'));
  }

  Future<void> _delete(Subject s) async {
    final yes = await _confirm(context, 'Delete subject', 'Delete ${s.subjectCode} - ${s.subjectName}?');
    if (!yes) return;
    final ok = await _vm.deleteSubject(s.id!);
    if (!mounted) return;
    _snack(ok ? 'Subject deleted.' : (_vm.errorMessage ?? 'Failed.'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          if (_vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (_vm.errorMessage != null && _vm.subjects.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_vm.errorMessage!),
                  FilledButton(onPressed: _vm.loadSubjects, child: const Text('Retry')),
                ],
              ),
            );
          }
          if (_vm.subjects.isEmpty) return const Center(child: Text('No subjects yet. Tap + to add one.'));
          return ListView.builder(
            itemCount: _vm.subjects.length,
            itemBuilder: (context, index) {
              final s = _vm.subjects[index];
              final count = s.scheduleCount ?? 0;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text('${s.subjectCode} - ${s.subjectName}'),
                  subtitle: Text('${s.units} unit(s) • ${count == 0 ? 'No schedule yet' : 'Available: $count schedule(s)'}'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SubjectDetailsScreen(subject: s)),
                    );
                    _vm.loadSubjects(); // schedule count may have changed
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _openForm(s)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(s)),
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

class _SubjectFormDialog extends StatefulWidget {
  final Subject? subject;
  const _SubjectFormDialog({this.subject});

  @override
  State<_SubjectFormDialog> createState() => _SubjectFormDialogState();
}

class _SubjectFormDialogState extends State<_SubjectFormDialog> {
  final _key = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.subject?.subjectCode);
  late final _name = TextEditingController(text: widget.subject?.subjectName);
  late final _units = TextEditingController(text: widget.subject?.units.toString());
  late final _desc = TextEditingController(text: widget.subject?.description);

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _units.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.pop(
      context,
      Subject(
        id: widget.subject?.id,
        subjectCode: _code.text.trim(),
        subjectName: _name.text.trim(),
        units: int.parse(_units.text.trim()),
        description: _desc.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject == null ? 'Add Subject' : 'Edit Subject'),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _code,
                maxLength: 20,
                decoration: const InputDecoration(labelText: 'Subject Code'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _name,
                maxLength: 100,
                decoration: const InputDecoration(labelText: 'Subject Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _units,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Units'),
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null) return 'Enter a number';
                  if (n < 1 || n > 12) return 'Units must be 1 - 12';
                  return null;
                },
              ),
              TextFormField(
                controller: _desc,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
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

// =====================================================================
// SUBJECT DETAILS  (shows the subject's schedules)
// =====================================================================
class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;
  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  final _vm = ScheduleViewModel();

  @override
  void initState() {
    super.initState();
    _vm.loadSchedules(subjectId: widget.subject.id);
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.subject;
    return Scaffold(
      appBar: AppBar(title: Text(s.subjectCode)),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.subjectName, style: Theme.of(context).textTheme.headlineSmall),
                    Text('${s.units} unit(s)'),
                    const SizedBox(height: 8),
                    Text(s.description.isEmpty ? 'No description.' : s.description),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ScheduleScreen(subject: s)),
                        );
                        _vm.loadSchedules(subjectId: s.id);
                      },
                      icon: const Icon(Icons.schedule),
                      label: const Text('Manage Schedules'),
                    ),
                    const SizedBox(height: 12),
                    Text('Schedules', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              Expanded(
                child: _vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _vm.schedules.isEmpty
                        ? const Center(child: Text('No schedules for this subject yet.'))
                        : ListView.builder(
                            itemCount: _vm.schedules.length,
                            itemBuilder: (context, i) {
                              final sc = _vm.schedules[i];
                              return ListTile(
                                leading: const Icon(Icons.access_time),
                                title: Text('${sc.dayOfWeek}  ${sc.timeLabel}'),
                                subtitle: Text('Room ${sc.room} • ${sc.slotsLeft} of ${sc.slotCapacity} slots left'),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
