import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Profile Data

// PROFILE 1
String ProfileImage1 = "assets/cutie.jpg";
String? name1 = "Julia Yashika Kong";
String? courseSection1 = "BSIT 3";
int age1 = 20;
String? hobby1 = null;

// PROFILE 2
String ProfileImage2 = "assets/meow.png";
String? name2 = "Emji Silento";
String? courseSection2 = null;
int age2 = 22;
String? hobby2 = "Drinking Alcohol";

// PROFILE 3
String ProfileImage3 = "assets/ha.jpg";
String? name3 = null;
String? courseSection3 = "BSIT 3";
int age3 = 21;
String? hobby3 = "Dancing";

// PROFILE 4
String ProfileImage4 = "assets/pretty.png";
String? name4 = "Karylle Racaza";
String? courseSection4 = "BSIT 3";
int age4 = 21;
String? hobby4 = "Dancing";

// PROFILE 5
String ProfileImage5 = "assets/sexy.jpg";
String? name5 = "Mav Sumalangit";
String? courseSection5 = "BSIT 3";
int age5 = 21;
String? hobby5 = "Singing & Dancing";

String appTitle = "My Profile";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7FF),
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'My First Flutter Application',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [


              Container(
                width: 220,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FA),
                  borderRadius: BorderRadius.circular(8),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // Profile Title
                    Center(
                      child: Text(
                        appTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Profile Image
                    Center(
                      child: Image.asset(
                        ProfileImage1,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      "Name: ${name1 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Course
                    Text(
                      "Course & Section: ${courseSection1 ?? "Unknown"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Age
                    Text(
                      "Age: $age1",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Hobby
                    Text(
                      "Hobby: ${hobby1 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              Container(
                width: 220,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FA),
                  borderRadius: BorderRadius.circular(8),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // Profile Title
                    Center(
                      child: Text(
                        appTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Profile Image
                    Center(
                      child: Image.asset(
                        ProfileImage2,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      "Name: ${name2 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Course
                    Text(
                      "Course & Section: ${courseSection2 ?? "Unknown"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Age
                    Text(
                      "Age: $age2",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Hobby
                    Text(
                      "Hobby: ${hobby2 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              // ================= PROFILE 3 =================

              Container(
                width: 220,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FA),
                  borderRadius: BorderRadius.circular(8),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // Profile Title
                    Center(
                      child: Text(
                        appTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Profile Image
                    Center(
                      child: Image.asset(
                        ProfileImage3,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      "Name: ${name3 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Course
                    Text(
                      "Course & Section: ${courseSection3 ?? "Unknown"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Age
                    Text(
                      "Age: $age3",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Hobby
                    Text(
                      "Hobby: ${hobby3 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              // ================= PROFILE 4 =================

              Container(
                width: 220,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FA),
                  borderRadius: BorderRadius.circular(8),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // Profile Title
                    Center(
                      child: Text(
                        appTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Profile Image
                    Center(
                      child: Image.asset(
                        ProfileImage4,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      "Name: ${name4 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Course
                    Text(
                      "Course & Section: ${courseSection4 ?? "Unknown"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Age
                    Text(
                      "Age: $age4",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Hobby
                    Text(
                      "Hobby: ${hobby4 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              // ================= PROFILE 5 =================

              Container(
                width: 220,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FA),
                  borderRadius: BorderRadius.circular(8),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    // Profile Title
                    Center(
                      child: Text(
                        appTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Profile Image
                    Center(
                      child: Image.asset(
                        ProfileImage5,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Name
                    Text(
                      "Name: ${name5 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Course
                    Text(
                      "Course & Section: ${courseSection5 ?? "Unknown"}",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Age
                    Text(
                      "Age: $age5",
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 6),

                    // Hobby
                    Text(
                      "Hobby: ${hobby5 ?? "Not provided"}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}