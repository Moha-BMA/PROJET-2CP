import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chainage1/app_state.dart';
import 'Introvideo.dart';
import 'MainScreen.dart'; // Replace with your actual MainScreen import

class ThirdScreen extends ConsumerStatefulWidget {
  const ThirdScreen({super.key});

  @override
  ThirdScreenState createState() => ThirdScreenState();
}

class ThirdScreenState extends ConsumerState<ThirdScreen> {
  final TextEditingController nameController = TextEditingController();
  int age = 3; // Default age value
  bool showNameError = false; // Flag to track if we should show error

  void increaseAge() {
    setState(() {
      if (age < 18)
      age++;
    });
  }

  void decreaseAge() {
    setState(() {
      if (age > 3) age--; // Prevent age below 3
    });
  }

  void validateAndNavigate(BuildContext context) {
    String name = nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        showNameError = true; // Set flag to true to show error
        nameController.clear(); // Clear the field to show the hint/error
      });
    } else {
      setState(() {
        showNameError = false;
      });
      // Save name, age, and user category
      ref.read(userNameProvider.notifier).setName(name);
      ref.read(userAgeProvider.notifier).setAge(age);
      ref.read(userCategoryProvider.notifier).setCategory(age >= 8);
      // Navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions - optimized for 2400x1080 display
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Values optimized for 2400x1080 phone
    final nameFieldWidth = screenWidth * 0.25; // 75% of width for name field
    final nameFieldHeight = screenHeight * 0.09; // Slightly smaller height
    final buttonSize = screenWidth * 0.06; // Slightly smaller buttons
    final fontSize = screenWidth * 0.02; // Smaller font size
    final ageTextSize = screenWidth * 0.035; // Age text size

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image that fills the screen
          Image.asset(
            'assets/assetsfirst5screens/img1.png',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
          ),

          // Name input field
          Positioned(
            top: screenHeight * 0.35,
            left: screenWidth * 0.35,
            width: nameFieldWidth,
            height: nameFieldHeight,
            child: TextField(
              controller: nameController,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                hintText: showNameError ? "عليك ادخال اسمك" : "الاسم",
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: showNameError
                        ? Colors.red
                        : const Color.fromARGB(255, 101, 98, 98),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                hintStyle: TextStyle(
                  fontSize: fontSize,
                  color: showNameError ? Colors.red : Colors.grey,
                  fontWeight: showNameError ? FontWeight.bold : FontWeight.normal,
                ),
                errorText: null,
              ),
              onChanged: (text) {
                if (showNameError && text.isNotEmpty) {
                  setState(() {
                    showNameError = false;
                  });
                }
              },
            ),
          ),

          // Age display in the center
          Positioned(
            top: screenHeight * 0.51,
            left: 0,
            right: 33,
            child: Center(
              child: Text(
                'سنة $age',
                style: TextStyle(
                  fontSize: ageTextSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Down arrow button
          Positioned(
            top: screenHeight * 0.5,
            left: screenWidth * 0.355,
            child: GestureDetector(
              onTap: decreaseAge,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                child: Image.asset(
                  'assets/assetsfirst5screens/down_arrow.png',
                  width: buttonSize,
                  height: buttonSize,
                ),
              ),
            ),
          ),

          // Up arrow button
          Positioned(
            top: screenHeight * 0.5,
            right: screenWidth * 0.40,
            child: GestureDetector(
              onTap: increaseAge,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                child: Image.asset(
                  'assets/assetsfirst5screens/up_arrow.png',
                  width: buttonSize,
                  height: buttonSize,
                ),
              ),
            ),
          ),

          // Registration button
          Positioned(
            bottom: screenHeight * 0.23,
            left: screenWidth * 0.35,
            width: screenWidth * 0.25,
            height: screenHeight * 0.09,
            child: GestureDetector(
              onTap: () => validateAndNavigate(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'التسجيل',
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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