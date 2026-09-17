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
              SizedBox(width:3),
              Text(
                'VALORANT 3',
                style: TextStyle(
                fontSize:17,
                fontFamily: 'sans-serif',
                fontWeight: FontWeight.bold,
                color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
       ),
            
       Card(
        color: Colors.black,
        margin:EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(padding: EdgeInsetsGeometry.only
        (top:0, bottom:15, left:28, right:17,),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
            backgroundColor: Color.fromARGB(255, 20, 20, 20),
            radius: 25,
            child: Icon(Icons.person, color: Colors.redAccent, size:40),                  
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 16, color: Colors.black),

                    SizedBox(width:10),
                    Icon(Icons.circle, size:18, color: Colors.greenAccent,),
                  ],
                )
              ],
            ),
             SizedBox(width:10),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MissYouLikeKrazy',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'sans-serif',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height:5),

          Row( 
            children: [
              Icon (
                Icons.monitor, size: 15, color: Colors.white,),
              SizedBox(width:3),
                Text(
                  'Online - VALORANT',
                style: TextStyle(
                fontSize:17,
                fontFamily: 'sans-serif',
                color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),       
    ]
  ),
),
),

       Card(
        color: Colors.black,
        margin:EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(padding: EdgeInsetsGeometry.only
        (top:0, bottom:15, left:28, right:17,),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
            backgroundColor: Color.fromARGB(255, 20, 20, 20),
            radius: 25,
            child: Icon(Icons.person, color: Colors.redAccent, size:40),                  
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 16, color: Colors.black),

                    SizedBox(width:10),
                     Icon(Icons.play_circle_fill, size: 16, color: Colors.blueAccent),
                  ],
                )
              ],
            ),
             SizedBox(width:10),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'bread',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'sans-serif',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height:5),

          Row( 
            children: [
              Icon (
                Icons.monitor, size: 15, color: Colors.white,),
              SizedBox(width:3),
                Text(
                  'Playing - VALORANT',
                style: TextStyle(
                fontSize:17,
                fontFamily: 'sans-serif',
                color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),       
    ]
  ),
),
),
       Card(
        color: Colors.black,
        margin:EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(padding: EdgeInsetsGeometry.only
        (top:0, bottom:15, left:28, right:17,),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
            backgroundColor: Color.fromARGB(255, 20, 20, 20),
            radius: 25,
            child: Icon(Icons.person, color: Colors.redAccent, size:40),                  
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 16, color: Colors.black),

                    SizedBox(width:10),
                     Icon(Icons.play_circle_fill, size: 16, color: Colors.blueAccent),
                  ],
                )
              ],
            ),
             SizedBox(width:10),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The14th',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'sans-serif',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height:5),

          Row( 
            children: [
              Icon (
                Icons.monitor, size: 15, color: Colors.white,),
              SizedBox(width:3),
                Text(
                  'Playing - VALORANT',
                style: TextStyle(
                fontSize:17,
                fontFamily: 'sans-serif',
                color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),       
    ]
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
              SizedBox(width:3),
              Text(
                'Online 4',
                style: TextStyle(
                fontSize:15,
                fontFamily: 'sans-serif',
                color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
       ),
       Card(
        color: Colors.black,
        margin:EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(padding: EdgeInsetsGeometry.only
        (top:0, bottom:15, left:28, right:17,),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
            backgroundColor: Color.fromARGB(255, 20, 20, 20),
            radius: 25,
            child: Icon(Icons.person, color: Colors.white, size:40),                  
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 16, color: Colors.black),

                    SizedBox(width:10),
                    Icon(Icons.dark_mode, size:18, color: Colors.yellowAccent,),
                  ],
                )
              ],
            ),
             SizedBox(width:10),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Carlvendish',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'sans-serif',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height:5),

          Row( 
            children: [
              Icon (
                Icons.phone_android, size: 15, color: Colors.white,),
              SizedBox(width:3),
                Text(
                  'Away - Riot Mobile',
                style: TextStyle(
                fontSize:17,
                fontFamily: 'sans-serif',
                color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),       
    ]
  ),
),
),       
       Card(
        color: Colors.black,
        margin:EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(padding: EdgeInsetsGeometry.only
        (top:0, bottom:15, left:28, right:17,),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
            backgroundColor: Color.fromARGB(255, 20, 20, 20),
            radius: 25,
            child: Icon(Icons.person, color: Colors.white, size:40),                  
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 16, color: Colors.black),

                    SizedBox(width:10),
                    Icon(Icons.dark_mode, size:18, color: Colors.yellowAccent,),
                  ],
                )
              ],
            ),
             SizedBox(width:10),
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'D1yah',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'sans-serif',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height:5),

          Row( 
            children: [
              Icon (
                Icons.phone_android, size: 15, color: Colors.white,),
              SizedBox(width:3),
                Text(
                  'Away - Riot Mobile',
                style: TextStyle(
                fontSize:17,
                fontFamily: 'sans-serif',
                color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),       
    ]
  ),
),
),
            

        
        
        
        ],
      ),
      )
    );
  }
}

 