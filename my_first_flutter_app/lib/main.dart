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
      home: const StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<bool> buttonPressed = [];
  List<bool> favoriteStudents = [];

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
      body: students.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "No students available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
                      "Student Card Tapped: ${student["name"]}",
                    );
                  },
                  child: Card(
                    key: ValueKey(student["studentID"]),
                    margin: const EdgeInsets.all(10),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // STUDENT IMAGE
                          Image.asset(
                            student["image"],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),

                          const SizedBox(height: 15),

                          // STUDENT NAME
                          Text(
                            student["name"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // STUDENT INFORMATION
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

                          const SizedBox(height: 15),

                          // FAVORITE ICON
                          Icon(
                            favoriteStudents[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 35,
                          ),

                          const SizedBox(height: 5),

                          // FAVORITE STATUS
                          Text(
                            favoriteStudents[index]
                                ? "Favorite"
                                : "Not Favorite",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

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

                          const SizedBox(height: 15),

                          // FAVORITE AND EDIT BUTTONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // FAVORITE BUTTON
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    buttonPressed[index] = true;
                                    favoriteStudents[index] =
                                        !favoriteStudents[index];
                                  });

                                  debugPrint(
                                    "Favorite button pressed for ${student["name"]}",
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
                                child: const Text("Favorite"),
                              ),

                              const SizedBox(width: 10),

                              // EDIT BUTTON
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    buttonPressed[index] = true;
                                  });

                                  debugPrint(
                                    "Edit button pressed for ${student["name"]}",
                                  );

                                  // FLAG 6: EDIT TRIGGER
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
                                            child: const Text(
                                              "Cancel",
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop();

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
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
                                            child: const Text(
                                              "Edit",
                                            ),
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

                          // DELETE BUTTON
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