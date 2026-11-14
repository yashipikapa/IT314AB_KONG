
import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailsScreen> createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {

  void editStudent() {
    final nameController =
        TextEditingController(text: widget.student["name"]);

    final emailController =
        TextEditingController(text: widget.student["email"]);

    final ageController = TextEditingController(
      text: widget.student["age"].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Student"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),

              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.student["name"] = nameController.text;
                  widget.student["email"] = emailController.text;
                  widget.student["age"] =
                      int.tryParse(ageController.text) ??
                      widget.student["age"];
                });

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      emailController.dispose();
      ageController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(student["image"]),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                student["name"],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text("Student ID: ${student["studentID"]}"),
            Text("Course: ${student["course"]}"),
            Text("Year Level: ${student["yearLevel"]}"),
            Text("Age: ${student["age"]}"),
            Text("Hobby: ${student["hobby"]}"),
            Text("Email: ${student["email"]}"),
            Text("Favorite Subject: ${student["favoriteSubject"]}"),
            Text(
              "Status: ${student["active"] ? "Active" : "Inactive"}",
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: editStudent,
                icon: const Icon(Icons.edit),
                label: const Text("Edit Student"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
