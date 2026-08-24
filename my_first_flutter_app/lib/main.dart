import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

List<Map<String, dynamic>> students = [
  {
    "image": "assets/cutie.jpg",
    "name": "Julia Yashika Kong",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 20,
    "hobby": "Eating",
    "studentID": "24060152",
    "email": "julia@gmail.com",
    "favoriteSubject": "Recess",
  },
  {
    "image": "assets/meow.png",
    "name": "Emji Silento",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 22,
    "hobby": "Drinking Alcohol",
    "studentID": "24060169",
    "email": "emji@gmail.com",
    "favoriteSubject": "Programming",
  },
  {
    "image": "assets/pretty.png",
    "name": "Leachim Dela Cerna",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 21,
    "hobby": "Dancing",
    "studentID": "24060130",
    "email": "leachim@gmail.com",
    "favoriteSubject": "Database Management",
  },
  {
    "image": "assets/ha.jpg",
    "name": "Karryle Racaza",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 21,
    "hobby": "Dancing",
    "studentID": "24060165",
    "email": "karryle@gmail.com",
    "favoriteSubject": "Web Development",
  },
  {
    "image": "assets/sexy.jpg",
    "name": "Mav Sumalangitka",
    "course": "BSIT",
    "yearLevel": 3,
    "age": 21,
    "hobby": "Dancing & Singing",
    "studentID": "24060168",
    "email": "mav@gmail.com",
    "favoriteSubject": "Networking",
  },
  {
    "image": "assets/mice.jpg",
    "name": "Bryan Kinnot",
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

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

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

                  SizedBox(height: 15),

                  Text(
                    "No students found.",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "The student list is currently empty.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )

          : ListView.builder(
              itemCount: students.length,

              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),

                  child: Padding(
                    padding: const EdgeInsets.all(10),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Image.asset(
                          students[index]["image"],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 50,
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 15),


                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                students[index]["name"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "Course: ${students[index]["course"]}",
                              ),

                              Text(
                                "Year Level: ${students[index]["yearLevel"]}",
                              ),

                              Text(
                                "Age: ${students[index]["age"]}",
                              ),

                              Text(
                                "Hobby: ${students[index]["hobby"]}",
                              ),

                              Text(
                                "Student ID: ${students[index]["studentID"]}",
                              ),

                              Text(
                                "Email: ${students[index]["email"]}",
                              ),

                              Text(
                                "Favorite Subject: "
                                "${students[index]["favoriteSubject"]}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}