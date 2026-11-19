import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> existingStudents;
  final Future<void> Function() onSave;

  const AddStudentScreen({
    super.key,
    required this.existingStudents,
    required this.onSave,
  });

  @override
  State<AddStudentScreen> createState() =>
      _AddStudentScreenState();
}

class _AddStudentScreenState
    extends State<AddStudentScreen> {
  final formKey = GlobalKey<FormState>();

  final studentIDController = TextEditingController();
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final yearLevelController = TextEditingController();
  final emailController = TextEditingController();


  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final studentID = studentIDController.text.trim();

    if (studentID.isNotEmpty) {
      final duplicate = widget.existingStudents.any(
        (student) =>
            student["studentID"].toString().trim() ==
            studentID,
      );

      if (duplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Student ID already exists."),
          ),
        );

        return;
      }
    }

    final newStudent = {
      "name": nameController.text.trim(),
      "image": null,
      "course": courseController.text.trim(),
      "yearLevel": int.parse(
        yearLevelController.text.trim(),
      ),
      "age": 0,
      "hobby": "N/A",
      "studentID": studentID.isEmpty ? null : studentID,
      "email": emailController.text.trim(),
      "favoriteSubject": "N/A",
      "active": true,
    };


    widget.existingStudents.add(newStudent);

    // SAVE STUDENTS
    await widget.onSave();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Student enrolled successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    studentIDController.dispose();
    nameController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              const Text(
                "Student Enrollment Form",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),

              const SizedBox(height: 20),

              // STUDENT ID - OPTIONAL
              TextFormField(
                controller: studentIDController,
                decoration: const InputDecoration(
                  labelText: "Student ID (Optional)",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }

                  final duplicate =
                      widget.existingStudents.any(
                    (student) =>
                        student["studentID"]
                            .toString()
                            .trim() ==
                        value.trim(),
                  );

                  if (duplicate) {
                    return "Student ID already exists.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter the student's name.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: "Course",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter the course.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              // YEAR LEVEL
              TextFormField(
                controller: yearLevelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Year Level",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter the year level.";
                  }

                  final year = int.tryParse(
                    value.trim(),
                  );

                  if (year == null ||
                      year < 1 ||
                      year > 4) {
                    return "Year Level must be between 1 and 4.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Please enter the email.";
                  }

                  if (!value.contains("@") ||
                      !value.contains(".")) {
                    return "Please enter a valid email.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: submitForm,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),

                child: const Text("Enroll Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}