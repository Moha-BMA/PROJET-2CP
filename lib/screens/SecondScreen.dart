import 'package:flutter/material.dart';
import 'ThirdScreen.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image that fills the screen
          Image.asset(
            'assets/assetsfirst5screens/img1.png',
            fit: BoxFit.cover,
            width: screenSize.width,
            height: screenSize.height,
          ),
          // Center the text directly on the background
          Positioned(

            left: screenSize.width*0.33,
            right: screenSize.width*0.37,
            bottom:screenSize.height*0.35 ,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'مرحبا بك في مغامرتنا',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.023,
                    color: Colors.white, // Text color set to white
                    fontWeight: FontWeight.bold,
                    shadows: [
                      // Simulate stroke by adding shadows in all directions
                      Shadow(
                        offset: Offset(-2, -2), // Top-left
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, -2), // Top-right
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(-2, 2), // Bottom-left
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, 2), // Bottom-right
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(0, -2), // Top
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(0, 2), // Bottom
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(-2, 0), // Left
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, 0), // Right
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
                Text(
                  'استعد للمغامرة الممتعة و التعليمية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.023,
                    color: Colors.white, // Text color set to white
                    shadows: [
                      Shadow(
                        offset: Offset(-2, -2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, -2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(-2, 2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, 2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(0, -2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(0, 2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(-2, 0),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, 0),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
                Text(
                  'سجل الآن و ابدأ االلعب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.023,
                    color: Colors.white, // Text color set to white
                    shadows: [
                      Shadow(
                        offset: Offset(-2, -2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, -2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(-2, 2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, 2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(0, -2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(0, 2),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(-2, 0),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                      Shadow(
                        offset: Offset(2, 0),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Position the button at the bottom center
          Positioned(
            bottom: screenSize.height * 0.2, // 5% from the bottom
            left:-screenSize.width*0.045 ,
            right: 0,
            child: Center(
              child: GestureDetector(
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
                  width: screenSize.width * 0.2, // 40% of screen width
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'ابدا الان',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.025,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}