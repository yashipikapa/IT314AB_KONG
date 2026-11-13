import 'package:flutter/material.dart';

void main() {
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

final List<Map<String, dynamic>> originalStudents = [
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

void sortStudents() {
  students.sort(
    (a, b) => a["name"].compareTo(b["name"]),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student List",
      home: const StudentListScreen(),
    );
  }
}


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

  void restoreStudents() {
    setState(() {
      students = List<Map<String, dynamic>>.from(
        originalStudents.map(
          (student) => Map<String, dynamic>.from(student),
        ),
      );

      buttonPressed = List<bool>.filled(
        students.length,
        false,
      );

      favoriteStudents = List<bool>.filled(
        students.length,
        false,
      );
    });

    sortStudents();

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
                      onTap: () {
                        debugPrint(
                          "Student card tapped: ${student["name"]}",
                        );

                        // FLAG 2 NAVIGATION
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const StudentDetailsScreen(),
                          ),
                        );
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

                              Text(
                                "Course: ${student["course"]}",
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                "Year Level: ${student["yearLevel"]}",
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                "Age: ${student["age"]}",
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                "Hobby: ${student["hobby"]}",
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                "Student ID: ${student["studentID"]}",
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                "Email: ${student["email"]}",
                                textAlign: TextAlign.center,
                              ),

                              Text(
                                "Favorite Subject: ${student["favoriteSubject"]}",
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 8),

                              // ACTIVE / INACTIVE
                              Text(
                                student["active"]
                                    ? "Active"
                                    : "Inactive",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // INACTIVE WARNING
                              if (student["active"] == false)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    "⚠ This student is inactive",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 8),

                              // FAVORITE STATUS
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
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // BUTTON STATUS
                              Text(
                                buttonPressed[index]
                                    ? "Button Status: Button Pressed"
                                    : "Button Status: Not Pressed",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        buttonPressed[index] = true;
                                        favoriteStudents[index] =
                                            !favoriteStudents[index];
                                      });

                                      debugPrint(
                                        "${student["name"]} favorite button pressed",
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            favoriteStudents[index]
                                                ? "${student["name"]} added to favorites!"
                                                : "${student["name"]} removed from favorites!",
                                          ),
                                          duration:
                                              const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          favoriteStudents[index]
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          favoriteStudents[index]
                                              ? "Favorite"
                                              : "Favorite",
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        buttonPressed[index] = true;
                                      });

                                      debugPrint(
                                        "Edit button pressed for ${student["name"]}",
                                      );

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Edit Student",
                                            ),
                                            content: Text(
                                              "You are about to edit ${student["name"]}.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop();
                                                },
                                                child:
                                                    const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop();

                                                  ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Edit action started for ${student["name"]}",
                                                      ),
                                                      duration:
                                                          const Duration(
                                                        seconds: 2,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child:
                                                    const Text("Edit"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text("Edit"),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              ElevatedButton(
                                onPressed: () {
                                  String deletedStudent =
                                      student["name"];

                                  setState(() {
                                    students.removeAt(index);
                                    buttonPressed.removeAt(index);
                                    favoriteStudents.removeAt(index);
                                  });

                                  debugPrint(
                                    "$deletedStudent deleted",
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "$deletedStudent deleted!",
                                      ),
                                      duration:
                                          const Duration(seconds: 2),
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



class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Text(
          "Student Details Screen",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}