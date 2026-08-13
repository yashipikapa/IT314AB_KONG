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
          backgroundColor: Colors.pink,
          title: const Text(
            'My First Flutter Application',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(25),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.flutter_dash,
                    size: 70,
                    color: Colors.pink,
                  ),


                  const SizedBox(height: 20),


                  // Circular profile picture
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.pink,
                        width: 5,
                      ),
                    ),

                    child: ClipOval(
                      child: Image.asset(
                        'assets/meow.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),



                  const SizedBox(height: 20),


                  const Text(
                    'Julia Yashika A. Kong',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),


                  const SizedBox(height: 10),


                  const Text(
                    'BSIT 3',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.pink,
                    ),
                  ),


                  const SizedBox(height: 20),


                  const Text(
                    'My First Flutter Application',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),


                  const SizedBox(height: 15),


                  const Text(
                    'August 11, 2026',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}





