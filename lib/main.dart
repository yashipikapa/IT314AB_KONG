import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'screens/add_student_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadStudents();

  runApp(const MyApp());
}

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


Future<void> saveStudents() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(
    "students",
    jsonEncode(students),
  );
}


Future<void> loadStudents() async {
  final prefs = await SharedPreferences.getInstance();

  final savedData = prefs.getString("students");

  if (savedData != null) {
    students = List<Map<String, dynamic>>.from(
      jsonDecode(savedData),
    );
  }
}



final List<Map<String, dynamic>> originalStudents = students
    .map((student) => Map<String, dynamic>.from(student))
    .toList();

// SORT STUDENTS

void sortStudents() {
  students.sort(
    (a, b) => a["name"].toString().compareTo(
          b["name"].toString(),
        ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student List",
      initialRoute: '/student-list',

      routes: {
        '/student-list': (context) =>
            const StudentListScreen(),

        // ADD STUDENT FORM
        '/add-student': (context) => AddStudentScreen(
              existingStudents: students,
              onSave: saveStudents,
            ),
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


class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState
    extends State<StudentListScreen> {
  List<bool> buttonPressed = [];
  List<bool> favoriteStudents = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    sortStudents();

    buttonPressed = List<bool>.filled(
      students.length,
      false,
    );

    favoriteStudents = List<bool>.filled(
      students.length,
      false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }


  Future<void> restoreStudents() async {
    setState(() {
      students = originalStudents
          .map((student) => Map<String, dynamic>.from(student))
          .toList();

      sortStudents();

      buttonPressed = List<bool>.filled(
        students.length,
        false,
      );

      favoriteStudents = List<bool>.filled(
        students.length,
        false,
      );
    });

    await saveStudents();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Students restored!"),
        duration: Duration(seconds: 2),
      ),
    );
  }



  void refreshStudents() {
    setState(() {
      sortStudents();

      buttonPressed = List<bool>.filled(
        students.length,
        false,
      );

      favoriteStudents = List<bool>.filled(
        students.length,
        false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: "Add Student",

            // ADD STUDENT NAVIGATION
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/add-student',
              );

              if (!context.mounted) return;

              if (result == true) {
                refreshStudents();
              }
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

                        if (!context.mounted) return;

                        refreshStudents();
                      },

                      child: Card(
                        key: ValueKey(
                          student["studentID"] ??
                              student["name"],
                        ),
                        margin: const EdgeInsets.all(10),
                        elevation: 4,

                        child: Padding(
                          padding: const EdgeInsets.all(15),

                          child: Column(
                            children: [
                              // STUDENT PROFILE PICTURE
                              student["image"] != null &&
                                      student["image"]
                                          .toString()
                                          .isNotEmpty
                                  ? Image.asset(
                                      student["image"].toString(),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : const CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.person,
                                        size: 70,
                                        color: Colors.white,
                                      ),
                                    ),

                              const SizedBox(height: 10),

                              Text(
                                student["name"]?.toString() ??
                                    "No name",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Course: ${student["course"] ?? "N/A"}",
                              ),

                              Text(
                                "Year Level: ${student["yearLevel"] ?? "N/A"}",
                              ),

                              Text(
                                "Age: ${student["age"] ?? "N/A"}",
                              ),

                              Text(
                                "Hobby: ${student["hobby"] ?? "N/A"}",
                              ),

                              Text(
                                "Student ID: ${student["studentID"] ?? "Not assigned"}",
                              ),

                              Text(
                                "Email: ${student["email"] ?? "N/A"}",
                              ),

                              Text(
                                "Favorite Subject: ${student["favoriteSubject"] ?? "N/A"}",
                              ),

                              const SizedBox(height: 8),

                              Text(
                                student["active"] == true
                                    ? "Active"
                                    : "Inactive",
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

                              // FAVORITE BUTTON

                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    buttonPressed[index] = true;

                                    favoriteStudents[index] =
                                        !favoriteStudents[index];
                                  });

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        favoriteStudents[index]
                                            ? "${student["name"]} added to favorites!"
                                            : "${student["name"]} removed from favorites!",
                                      ),
                                      duration: const Duration(
                                        seconds: 2,
                                      ),
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
                                    const SizedBox(height: 5),
                                    const Text("Favorite"),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),


                                ElevatedButton(
                                  onPressed: () async {
                                    // CONFIRM DELETE
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          title: const Text("Delete Student"),
                                          content: Text(
                                            "Are you sure you want to delete ${student["name"]}?",
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
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (!context.mounted) return;

                
                                    if (confirm != true) return;

                                    final deletedStudent = student["name"] ?? "Student";

                 
                                    setState(() {
                                      students.remove(student);

                                      buttonPressed = List<bool>.filled(
                                        students.length,
                                        false,
                                      );

                                      favoriteStudents = List<bool>.filled(
                                        students.length,
                                        false,
                                      );
                                    });

            
                                    await saveStudents();

                                    if (!context.mounted) return;

  
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

  // EDIT STUDENT

  Future<void> editStudent() async {
    final nameController = TextEditingController(
      text: widget.student["name"]?.toString() ?? "",
    );

    final idController = TextEditingController(
      text: widget.student["studentID"]?.toString() ?? "",
    );

    final courseController = TextEditingController(
      text: widget.student["course"]?.toString() ?? "",
    );

    final yearController = TextEditingController(
      text: widget.student["yearLevel"]?.toString() ?? "",
    );

    final ageController = TextEditingController(
      text: widget.student["age"]?.toString() ?? "",
    );

    final hobbyController = TextEditingController(
      text: widget.student["hobby"]?.toString() ?? "",
    );

    final emailController = TextEditingController(
      text: widget.student["email"]?.toString() ?? "",
    );

    final subjectController = TextEditingController(
      text: widget.student["favoriteSubject"]?.toString() ?? "",
    );

    bool active = widget.student["active"] ?? true;

   

    void disposeControllers() {
      nameController.dispose();
      idController.dispose();
      courseController.dispose();
      yearController.dispose();
      ageController.dispose();
      hobbyController.dispose();
      emailController.dispose();
      subjectController.dispose();
    }

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
                    if (nameController.text.trim().isEmpty ||
                        courseController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(dialogContext)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please fill in all required fields.",
                          ),
                        ),
                      );

                      return;
                    }

                    final year = int.tryParse(
                      yearController.text.trim(),
                    );

                    if (year == null || year < 1 || year > 4) {
                      ScaffoldMessenger.of(dialogContext)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Year Level must be between 1 and 4.",
                          ),
                        ),
                      );

                      return;
                    }

                    final age = int.tryParse(
                      ageController.text.trim(),
                    );

                    if (age == null || age < 0) {
                      ScaffoldMessenger.of(dialogContext)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please enter a valid age.",
                          ),
                        ),
                      );

                      return;
                    }

                    final newStudentID =
                        idController.text.trim();

                    if (newStudentID.isNotEmpty) {
                      final duplicate = students.any(
                        (s) =>
                            !identical(s, widget.student) &&
                            s["studentID"]
                                    ?.toString()
                                    .trim() ==
                                newStudentID,
                      );

                      if (duplicate) {
                        ScaffoldMessenger.of(dialogContext)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Student ID already exists.",
                            ),
                          ),
                        );

                        return;
                      }
                    }

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

    if (!mounted) {
      disposeControllers();
      return;
    }

    if (result == true) {

      setState(() {
        widget.student["name"] =
            nameController.text.trim();

        widget.student["studentID"] =
            idController.text.trim().isEmpty
                ? null
                : idController.text.trim();

        widget.student["course"] =
            courseController.text.trim();

        widget.student["yearLevel"] =
            int.parse(yearController.text.trim());

        widget.student["age"] =
            int.parse(ageController.text.trim());

        widget.student["hobby"] =
            hobbyController.text.trim();

        widget.student["email"] =
            emailController.text.trim();

        widget.student["favoriteSubject"] =
            subjectController.text.trim();

        widget.student["active"] = active;
      });

      await saveStudents();

      if (!mounted) {
        disposeControllers();
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student information updated!"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    disposeControllers();
  }

  // STUDENT DETAILS ROW

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
              // PROFILE PICTURE OR DEFAULT ICON
              widget.student["image"] != null &&
                      widget.student["image"]
                          .toString()
                          .isNotEmpty
                  ? Image.asset(
                      widget.student["image"].toString(),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : const CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),

              const SizedBox(height: 15),

              Text(
                widget.student["name"]?.toString() ??
                    "No name",
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
                        widget.student["studentID"]
                                ?.toString() ??
                            "Not assigned",
                      ),

                      detailRow(
                        "Course",
                        widget.student["course"]
                                ?.toString() ??
                            "N/A",
                      ),

                      detailRow(
                        "Year Level",
                        widget.student["yearLevel"]
                                ?.toString() ??
                            "N/A",
                      ),

                      detailRow(
                        "Age",
                        widget.student["age"]
                                ?.toString() ??
                            "N/A",
                      ),

                      detailRow(
                        "Hobby",
                        widget.student["hobby"]
                                ?.toString() ??
                            "N/A",
                      ),

                      detailRow(
                        "Email",
                        widget.student["email"]
                                ?.toString() ??
                            "N/A",
                      ),

                      detailRow(
                        "Favorite Subject",
                        widget.student["favoriteSubject"]
                                ?.toString() ??
                            "N/A",
                      ),

                      detailRow(
                        "Status",
                        widget.student["active"] == true
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