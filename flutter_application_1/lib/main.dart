import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 65, 65, 65),
      ),
      home: const MyHomePage(title: 'Social'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Social',
        style:TextStyle(
          fontSize:35,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lucida Console',
        ),
       ),
      ),
      body: Center (child: Column(
        mainAxisAlignment: .start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            color: Colors.black,
            child: Padding(padding: EdgeInsetsGeometry.all(16.0),
            child: Row(
              children: [
                Text(
                  'Friends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans-serif',
                  ),
                ),

                SizedBox (width: 20),

                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'sans-serif',
                    color:Colors.grey,
                  ),
                ),

                SizedBox (width: 20),

                Text(
                  'Requests',
                  style:TextStyle(
                    fontSize: 18,
                    fontFamily: 'sans-serif',
                    color: Colors.grey,
                  ),
                ),
              ],
            )

          ),
        ),

        Card (
          margin:EdgeInsets.only (top: 1, bottom: 0, left: 0, right: 0),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.zero),
          color: Colors.black,
          child: Padding (padding: EdgeInsetsGeometry.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius:BorderRadiusGeometry.circular(15),
            ),
            child:Padding(padding: EdgeInsetsGeometry.all(10.0),
            child:Row(
              children: [
                Icon(Icons.search, size: 30, color: Colors.white,),  
                SizedBox(width:5),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize:20,
                    fontFamily: 'sans-serif',
                    color: Colors.white54,
                  ),
                )
              ],
            ),
            ),
          ),
          ),
        ),
        Card(
          color: Colors.black,
          margin:EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.zero),
          child: Padding(padding: EdgeInsetsGeometry.only(top: 0, bottom: 16, left: 25, right: 16,),
          child: Row(
            children: [
              Icon(Icons.circle_rounded, 
              size:30,
              color:Colors.redAccent,
              ),
            

            ]
          )
        ),
        

        ),



      ],
    ),
  )

    
    );
  }
}


  

 