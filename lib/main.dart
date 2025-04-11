import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'dart:async';

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

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      // Navigate to the SecondScreen after the timer ends
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecondScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          rive.RiveAnimation.asset(
            'assets/loading_bar (2).riv', // Ensure this path and file exist
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
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/img.png'), // Background image
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // Adds rounded corners
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 30,
                    ),
                    child: Text(
                      'مرحبا بك في مغامرتنا',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 45), // Add vertical space between the texts
                  Text(
                    'استعد لمغامرة ممتعة و تعليمية',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 177, 52, 52),
                    ),
                  ),
                  Text(
                    'سجل الآن و ابدأ العب.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 55, 55, 55),
                    ),
                  ),
                  SizedBox(height: 45), // Space above the button
                  GestureDetector(
                    onTap: () {
                      // Navigate to ThirdScreen when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ThirdScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 170,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // Adds rounded corners
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ابدا الان',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  ThirdScreenState createState() => ThirdScreenState();
}

class ThirdScreenState extends State<ThirdScreen> {
  final TextEditingController nameController = TextEditingController();
  int age = 0; // Default age value

  void increaseAge() {
    setState(() {
      age++;
    });
  }

  void decreaseAge() {
    setState(() {
      if (age > 0) age--; // Prevent negative age
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/img.png'),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: 170,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(255, 101, 98, 98),
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: nameController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          hintText: "الاسم",
                          contentPadding: EdgeInsets.only(bottom: 18),
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      GestureDetector(
                        onTap: decreaseAge,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2), // Border applied

                          ),
                          padding: EdgeInsets.all(5), // Space inside the border
                          child: Icon(Icons.arrow_downward, size: 16, color: Colors.blue),
                        ),
                      ),
SizedBox(width: 2),

                        Text(
                          '$ageسنة', // Display selected age
                          style: TextStyle(fontSize: 16),
                        ),

                      SizedBox(width: 2),

                      GestureDetector(
                        onTap: increaseAge,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2), // Border applied

                          ),
                          padding: EdgeInsets.all(5), // Space inside the border
                          child: Icon(Icons.arrow_upward, size: 16, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: GestureDetector(
                      onTap: () {
                        String name = nameController.text;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => FourthScreen(name: name, age: age),
                          ),
                        );
                      },
                      child: Container(
                        width: 170,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'التسجيل',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FourthScreen extends StatelessWidget {
  final String name;
  final int age;
  late final String mes; // Declare mes correctly

  // Define messages

  // Correct Constructor
  FourthScreen({super.key, required this.name, required this.age}) {
    final String s1 =
        "يبدو ان عمرك يساوي $age وعليه إذن سوف يتم اختيارك إلى لعب المسار الاتي\n مسار الاستكشاف للصغار";
    final String s2 =
        "يبدو ان عمرك يساوي $age وعليه إذن سوف يتم اختيارك إلى لعب المسار الاتي \nمسار التعلم للكبار";
    if (age < 8) {
      mes = s1;
    } else {
      mes = s2;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
  'assets/img_2.png',

),

            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 20, right: 30),
                    child: Text(
                      "مرحبا مرة اخرى يا",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only( left: 20, right: 30),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// Adding a horizontal line separator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.grey, // Line color
                      thickness: 2, // Line thickness
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only( left: 20, right: 30),
                    child: Text(
                      mes,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.grey, // Line color
                      thickness: 2, // Line thickness
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only( left: 20, right: 30),
                    child: Text(
                      "هيا لننطلق في الاستكشاف",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 227, 55, 55),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
