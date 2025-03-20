import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          rive.RiveAnimation.asset('assets/loading_bar (2).riv'),
        GestureDetector(
        onTap: () {
          // Navigate to the Second Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecondScreen()),
          );
        }
        ),
    ],
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
      ),
      body: Center(
        child: (
          Stack(
            alignment: Alignment.center ,
            children:[
              Image.asset('assets/img.png'),
           Container(
width: 200,
             height: 200,
             color: Colors.white,
             alignment: Alignment.topCenter,
            child:  Stack(
              children: [
                Text(
                  'مرحبا بك في مغامرتنا',
                  style: TextStyle(

                      fontSize: 15,
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                  )
              ),]


            )

           ),






            ],
    )
    ),

      ),
    );
  }
}
