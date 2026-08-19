import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.pink.shade50,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'My First Flutter Application',
            style: TextStyle(
              color: Colors.pink,
              fontSize: 16,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [

                // CARD 1 - PROFILE
                Card(
                  color: const Color.fromARGB(255, 241, 140, 174)
                      .withOpacity(0.35),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 30, 16, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Circular Profile Picture
                        Container(
                          width: 120,
                          height: 120,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.pink,
                              width: 4,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/meow.png',
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Name
                        const Text(
                          'Julia Yashika A. Kong',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // Course
                        const Text(
                          'BSIT 3',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Application
                        const Text(
                          'My First Flutter Application',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Date
                        const Text(
                          'August 11, 2026',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Hobby
                        const Text(
                          'Hobby: Eating',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 2),

                        // Age and Birthday
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Age: 20',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 12,
                              ),
                            ),

                            SizedBox(width: 25),

                            Text(
                              'Birthday: March 13, 2006',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CARD 2 - FAVORITES
                Card(
                  color: const Color.fromARGB(255, 241, 140, 174)
                      .withOpacity(0.35),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [

                        // My Favorites title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [

                            SizedBox(width: 5),
                            
                            Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 20,
                            ),

                            Text(
                              'My Favorites',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(width: 5),
 
                            Icon(
                              Icons.favorite,
                              color: Colors.pink,
                              size: 20,
                            ),

                          ],
                        ),

                        const SizedBox(height: 18),

                        // Favorites
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Game: Mobile Legends',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 11,
                              ),
                            ),

                            SizedBox(width: 20),

                            Text(
                              'Movie: Avatar: Fire and Ash',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Color: Pink',
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}