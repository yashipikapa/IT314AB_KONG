
import 'package:flutter/material.dart';
import 'student_data.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My First Flutter Application"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Student",
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/add-student',
                );

                if (result == true) {
                  setState(() {});
                }
              },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(student["image"]),
              ),

              title: Text(student["name"]),

              subtitle: Text(
                "${student["course"]} - Year ${student["yearLevel"]}",
              ),

              trailing: Icon(
                student["active"]
                    ? Icons.check_circle
                    : Icons.cancel,
                color: student["active"]
                    ? Colors.green
                    : Colors.red,
              ),

              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  '/student-details',
                  arguments: student,
                );

                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }
}
