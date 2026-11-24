import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../models/subject.dart';
import '../../viewmodels/schedule_viewmodel.dart';

const List<String> kDays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];

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

/// Shows every schedule, or only the schedules of [subject] when it is given.
class ScheduleScreen extends StatefulWidget {
  final Subject? subject;
  const ScheduleScreen({super.key, this.subject});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _vm = ScheduleViewModel();

  @override
  void initState() {
    super.initState();
    _vm.loadSchedules(subjectId: widget.subject?.id);
    _vm.loadSubjects();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _openForm([Schedule? schedule]) async {
    if (_vm.subjects.isEmpty) {
      _snack('Add a subject first.');
      return;
    }
    final result = await showDialog<Schedule>(
      context: context,
      builder: (_) => _ScheduleFormDialog(
        schedule: schedule,
        subjects: _vm.subjects,
        lockedSubjectId: widget.subject?.id,
      ),
    );
    if (result == null) return;
    final ok = await _vm.saveSchedule(result, reloadSubjectId: widget.subject?.id);
    if (!mounted) return;
    _snack(ok ? (schedule == null ? 'Schedule added.' : 'Schedule updated.') : (_vm.errorMessage ?? 'Failed.'));
  }

  Future<void> _delete(Schedule s) async {
    final yes = await _confirm(context, 'Delete schedule', 'Delete ${s.dayOfWeek} ${s.timeLabel}?');
    if (!yes) return;
    final ok = await _vm.deleteSchedule(s.id!, reloadSubjectId: widget.subject?.id);
    if (!mounted) return;
    _snack(ok ? 'Schedule deleted.' : (_vm.errorMessage ?? 'Failed.'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject == null ? 'Schedules' : '${widget.subject!.subjectCode} Schedules'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          if (_vm.isLoading) return const Center(child: CircularProgressIndicator());
          if (_vm.errorMessage != null && _vm.schedules.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_vm.errorMessage!),
                  FilledButton(
                    onPressed: () => _vm.loadSchedules(subjectId: widget.subject?.id),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (_vm.schedules.isEmpty) return const Center(child: Text('No schedules yet. Tap + to add one.'));
          return ListView.builder(
            itemCount: _vm.schedules.length,
            itemBuilder: (context, index) {
              final s = _vm.schedules[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ListTile(
                  title: Text('${s.subjectCode} • ${s.dayOfWeek} ${s.timeLabel}'),
                  subtitle: Text('${s.subjectName}\nRoom ${s.room} • ${s.slotsLeft} of ${s.slotCapacity} slots left'),
                  isThreeLine: true,
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

class _ScheduleFormDialog extends StatefulWidget {
  final Schedule? schedule;
  final List<Subject> subjects;
  final int? lockedSubjectId;
  const _ScheduleFormDialog({this.schedule, required this.subjects, this.lockedSubjectId});

  @override
  State<_ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<_ScheduleFormDialog> {
  final _key = GlobalKey<FormState>();
  late final _room = TextEditingController(text: widget.schedule?.room);
  late final _capacity = TextEditingController(text: widget.schedule?.slotCapacity.toString());
  late final _startCtrl = TextEditingController();
  late final _endCtrl = TextEditingController();
  int? _subjectId;
  String? _day;
  String? _start; // 'HH:mm:ss'
  String? _end;

  @override
  void initState() {
    super.initState();
    _subjectId = widget.schedule?.subjectId ?? widget.lockedSubjectId;
    _day = widget.schedule?.dayOfWeek;
    _start = widget.schedule?.startTime;
    _end = widget.schedule?.endTime;
    _startCtrl.text = _start == null ? '' : _start!.substring(0, 5);
    _endCtrl.text = _end == null ? '' : _end!.substring(0, 5);
  }

  @override
  void dispose() {
    _room.dispose();
    _capacity.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _pick(bool isStart) async {
    final current = (isStart ? _start : _end) ?? '08:00:00';
    final parts = current.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = _fmt(picked);
        _startCtrl.text = _start!.substring(0, 5);
      } else {
        _end = _fmt(picked);
        _endCtrl.text = _end!.substring(0, 5);
      }
    });
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.pop(
      context,
      Schedule(
        id: widget.schedule?.id,
        subjectId: _subjectId!,
        dayOfWeek: _day!,
        startTime: _start!,
        endTime: _end!,
        room: _room.text.trim(),
        slotCapacity: int.parse(_capacity.text.trim()),
        enrolledCount: widget.schedule?.enrolledCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.schedule == null ? 'Add Schedule' : 'Edit Schedule'),
      content: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _subjectId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Subject'),
                items: [
                  for (final s in widget.subjects)
                    DropdownMenuItem(value: s.id!, child: Text('${s.subjectCode} - ${s.subjectName}', overflow: TextOverflow.ellipsis)),
                ],
                onChanged: widget.lockedSubjectId != null ? null : (v) => setState(() => _subjectId = v),
                validator: (v) => v == null ? 'Select a subject' : null,
              ),
              DropdownButtonFormField<String>(
                value: _day,
                decoration: const InputDecoration(labelText: 'Day of week'),
                items: [for (final d in kDays) DropdownMenuItem(value: d, child: Text(d))],
                onChanged: (v) => setState(() => _day = v),
                validator: (v) => v == null ? 'Select a day' : null,
              ),
              TextFormField(
                controller: _startCtrl,
                readOnly: true,
                onTap: () => _pick(true),
                decoration: const InputDecoration(labelText: 'Start time', suffixIcon: Icon(Icons.access_time)),
                validator: (v) => (_start == null) ? 'Pick a start time' : null,
              ),
              TextFormField(
                controller: _endCtrl,
                readOnly: true,
                onTap: () => _pick(false),
                decoration: const InputDecoration(labelText: 'End time', suffixIcon: Icon(Icons.access_time)),
                validator: (v) {
                  if (_end == null) return 'Pick an end time';
                  if (_start != null && _end!.compareTo(_start!) <= 0) return 'Must be after start time';
                  return null;
                },
              ),
              TextFormField(
                controller: _room,
                maxLength: 30,
                decoration: const InputDecoration(labelText: 'Room'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _capacity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Slot capacity'),
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null || n < 1) return 'Enter a number of at least 1';
                  return null;
                },
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
