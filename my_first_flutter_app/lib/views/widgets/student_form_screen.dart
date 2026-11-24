import 'package:flutter/material.dart';
import '../../models/student.dart';
import '../../viewmodels/student_viewmodel.dart';

/// Used for BOTH creating (student == null) and editing (student != null).
class StudentFormScreen extends StatefulWidget {
  final Student? student;
  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vm = StudentViewModel();

  late final _number = TextEditingController(text: widget.student?.studentNumber);
  late final _name = TextEditingController(text: widget.student?.studentName);
  late final _email = TextEditingController(text: widget.student?.email);
  late final _contact = TextEditingController(text: widget.student?.contactNumber);
  int? _programId;
  int _yearLevel = 1;

  bool get _isEdit => widget.student != null;

  @override
  void initState() {
    super.initState();
    _programId = widget.student?.programId;
    _yearLevel = widget.student?.yearLevel ?? 1;
    _vm.loadPrograms();
  }

  @override
  void dispose() {
    _number.dispose();
    _name.dispose();
    _email.dispose();
    _contact.dispose();
    _vm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final student = Student(
      id: widget.student?.id,
      studentNumber: _number.text.trim(),
      studentName: _name.text.trim(),
      email: _email.text.trim(),
      programId: _programId,
      yearLevel: _yearLevel,
      contactNumber: _contact.text.trim(),
    );
    final ok = await _vm.saveStudent(student);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Student updated.' : 'Student created.')),
      );
      Navigator.pop(context, true); // tell the previous screen to refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_vm.errorMessage ?? 'Failed to save.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Student' : 'Add Student')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          final programValid = _vm.programs.any((p) => p.id == _programId);
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _number,
                  maxLength: 20,
                  decoration: const InputDecoration(labelText: 'Student Number', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Student number is required' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _name,
                  maxLength: 100,
                  decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _email,
                  maxLength: 100,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Email is required';
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: programValid ? _programId : null,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Program', border: OutlineInputBorder()),
                  items: [
                    for (final p in _vm.programs)
                      DropdownMenuItem(value: p.id, child: Text('${p.code} - ${p.name}', overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (v) => setState(() => _programId = v),
                  validator: (v) => v == null ? 'Select a program' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _yearLevel,
                  decoration: const InputDecoration(labelText: 'Year Level', border: OutlineInputBorder()),
                  items: [for (var i = 1; i <= 6; i++) DropdownMenuItem(value: i, child: Text('Year $i'))],
                  onChanged: (v) => setState(() => _yearLevel = v ?? 1),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contact,
                  maxLength: 20,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Contact Number', border: OutlineInputBorder()),
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Contact number is required';
                    if (!RegExp(r'^[0-9+\-\s]{7,20}$').hasMatch(value)) return 'Enter a valid contact number';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _vm.isSaving ? null : _save,
                  icon: _vm.isSaving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(_isEdit ? 'Update Student' : 'Save Student'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
