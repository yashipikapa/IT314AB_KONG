
import 'package:flutter/material.dart';
import 'screens/add_student_screen.dart';

void main() {
  runApp(const MyApp());
}

// STUDENT DATA

List<Map<String, dynamic>> students = [
  {
    "name": "Julia Yashika Kong",
    "image": "assets/cutie.jpg",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 20,
    "hobby": "Eating",
    "studentID": "24060152",
    "email": "julia@gmail.com",
    "favoriteSubject": "Recess",
    "active": true,
  },
  {
    "name": "Emji Silento",
    "image": "assets/meow.png",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 22,
    "hobby": "Drinking Alcohol",
    "studentID": "24060169",
    "email": "emji@gmail.com",
    "favoriteSubject": "Programming",
    "active": false,
  },
  {
    "name": "Leachim Dela Cerna",
    "image": "assets/pretty.png",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 21,
    "hobby": "Dancing",
    "studentID": "24060130",
    "email": "leachim@gmail.com",
    "favoriteSubject": "Database Management",
    "active": true,
  },
  {
    "name": "Karryle Racaza",
    "image": "assets/ha.jpg",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 21,
    "hobby": "Dancing",
    "studentID": "24060165",
    "email": "karryle@gmail.com",
    "favoriteSubject": "Web Development",
    "active": false,
  },
  {
    "name": "Mav Sumalangitka",
    "image": "assets/sexy.jpg",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 21,
    "hobby": "Dancing & Singing",
    "studentID": "24060168",
    "email": "mav@gmail.com",
    "favoriteSubject": "Networking",
    "active": true,
  },
  {
    "name": "Bryan Kinnot",
    "image": "assets/mice.jpg",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 21,
    "hobby": "Playing Games",
    "studentID": "24060172",
    "email": "bryan@gmail.com",
    "favoriteSubject": "Programming",
    "active": false,
  },
];

final List<Map<String, dynamic>> originalStudents = students
    .map((student) => Map<String, dynamic>.from(student))
    .toList();

void sortStudents() {
  students.sort((a, b) => a["name"].compareTo(b["name"]));
}

// MAIN APP AND NAMED ROUTES

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student List",

      initialRoute: '/student-list',

      routes: {
        '/student-list': (context) => const StudentListScreen(),

        '/add-student': (context) => const AddStudentScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/student-details') {
          final student =
              settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (context) {
              return StudentDetailsScreen(
                student: student,
              );
            },
          );
        }

        return null;
      },
    );
  }
}

// STUDENT LIST SCREEN

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<bool> buttonPressed = [];
  List<bool> favoriteStudents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    buttonPressed = List<bool>.filled(students.length, false);
    favoriteStudents = List<bool>.filled(students.length, false);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void restoreStudents() {
    setState(() {
      students = originalStudents
          .map((student) => Map<String, dynamic>.from(student))
          .toList();

      buttonPressed = List<bool>.filled(students.length, false);
      favoriteStudents = List<bool>.filled(students.length, false);

      sortStudents();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Students restored!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sortStudents();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: "Add Student",
            onPressed: () {
              Navigator.pushNamed(context, '/add-student');
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text(
                    "Loading students...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )

          : students.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "No students found",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "There are currently no students in the directory.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: restoreStudents,
                        child: const Text("Restore Students"),
                      ),
                    ],
                  ),
                )

              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          '/student-details',
                          arguments: student,
                        );

                        if (mounted) {
                          setState(() {});
                        }
                      },

                      child: Card(
                        key: ValueKey(student["studentID"]),
                        margin: const EdgeInsets.all(10),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Image.asset(
                                student["image"],
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),

                              const SizedBox(height: 10),

                              Text(
                                student["name"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text("Course: ${student["course"]}"),
                              Text("Year Level: ${student["yearLevel"]}"),
                              Text("Age: ${student["age"]}"),
                              Text("Hobby: ${student["hobby"]}"),
                              Text("Student ID: ${student["studentID"]}"),
                              Text("Email: ${student["email"]}"),
                              Text(
                                "Favorite Subject: ${student["favoriteSubject"]}",
                              ),

                              const SizedBox(height: 8),

                              Text(
                                student["active"] ? "Active" : "Inactive",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              if (student["active"] == false)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "⚠ This student is inactive",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 8),

                              Icon(
                                favoriteStudents[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 35,
                              ),

                              Text(
                                favoriteStudents[index]
                                    ? "Favorite"
                                    : "Not Favorite",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                buttonPressed[index]
                                    ? "Button Status: Button Pressed"
                                    : "Button Status: Not Pressed",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    buttonPressed[index] = true;
                                    favoriteStudents[index] =
                                        !favoriteStudents[index];
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        favoriteStudents[index]
                                            ? "${student["name"]} added to favorites!"
                                            : "${student["name"]} removed from favorites!",
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      favoriteStudents[index]
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text("Favorite"),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),

                              ElevatedButton(
                                onPressed: () {
                                  final deletedStudent = student["name"];

                                  setState(() {
                                    students.removeAt(index);
                                    buttonPressed.removeAt(index);
                                    favoriteStudents.removeAt(index);
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("$deletedStudent deleted!"),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// STUDENT DETAILS SCREEN AND EDIT MODAL

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

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  Future<void> editStudent() async {
    final nameController =
        TextEditingController(text: widget.student["name"]);

    final idController =
        TextEditingController(text: widget.student["studentID"]);

    final courseController =
        TextEditingController(text: widget.student["course"]);

    final yearController =
        TextEditingController(text: widget.student["yearLevel"].toString());

    final ageController =
        TextEditingController(text: widget.student["age"].toString());

    final hobbyController =
        TextEditingController(text: widget.student["hobby"]);

    final emailController =
        TextEditingController(text: widget.student["email"]);

    final subjectController =
        TextEditingController(text: widget.student["favoriteSubject"]);

    bool active = widget.student["active"];

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: const Text("Edit Student Information"),

              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: "Student ID",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: courseController,
                        decoration: const InputDecoration(
                          labelText: "Course",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Year Level",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Age",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: hobbyController,
                        decoration: const InputDecoration(
                          labelText: "Hobby",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: subjectController,
                        decoration: const InputDecoration(
                          labelText: "Favorite Subject",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Active Student"),
                        value: active,
                        onChanged: (value) {
                          dialogSetState(() {
                            active = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted) return;

    if (result == true) {
      setState(() {
        widget.student["name"] = nameController.text;
        widget.student["studentID"] = idController.text;
        widget.student["course"] = courseController.text;

        widget.student["yearLevel"] =
            int.tryParse(yearController.text) ??
            widget.student["yearLevel"];

        widget.student["age"] =
            int.tryParse(ageController.text) ??
            widget.student["age"];

        widget.student["hobby"] = hobbyController.text;
        widget.student["email"] = emailController.text;
        widget.student["favoriteSubject"] = subjectController.text;
        widget.student["active"] = active;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student information updated!"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    nameController.dispose();
    idController.dispose();
    courseController.dispose();
    yearController.dispose();
    ageController.dispose();
    hobbyController.dispose();
    emailController.dispose();
    subjectController.dispose();
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                widget.student["image"],
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 15),

              Text(
                widget.student["name"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailRow(
                        "Student ID",
                        widget.student["studentID"],
                      ),
                      detailRow(
                        "Course",
                        widget.student["course"],
                      ),
                      detailRow(
                        "Year Level",
                        widget.student["yearLevel"].toString(),
                      ),
                      detailRow(
                        "Age",
                        widget.student["age"].toString(),
                      ),
                      detailRow(
                        "Hobby",
                        widget.student["hobby"],
                      ),
                      detailRow(
                        "Email",
                        widget.student["email"],
                      ),
                      detailRow(
                        "Favorite Subject",
                        widget.student["favoriteSubject"],
                      ),
                      detailRow(
                        "Status",
                        widget.student["active"]
                            ? "Active"
                            : "Inactive",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: editStudent,
                icon: const Icon(Icons.edit),
                label: const Text("Edit Student"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
