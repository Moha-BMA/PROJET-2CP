import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'package:chainage1/app_state.dart'; // Import the app state file

class CardProgress extends ConsumerWidget {
  const CardProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    // Watch the star count of the last stage of each wilaya
    final w1LastStageStars = ref.watch(w1Stage3StarsProvider); // Wilaya 1, Stage 3
    final w2LastStageStars = ref.watch(w2Stage2StarsProvider); // Wilaya 2, Stage 2
    final w3LastStageStars = ref.watch(w3Stage2StarsProvider); // Wilaya 3, Stage 2
    final w4LastStageStars = ref.watch(w4Stage2StarsProvider); // Wilaya 4, Stage 2
    final w5LastStageStars = ref.watch(w5Stage4StarsProvider); // Wilaya 5, Stage 4
    final w6LastStageStars = ref.watch(w6Stage3StarsProvider); // Wilaya 6, Stage 3

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background
          Positioned.fill(
            child: Image.asset(
              'assets/assetscard/cards/CARDVIEW.png',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
          ),
          // Conditionally display wilaya parts based on last stage star count
          if (w1LastStageStars > 0)
            Positioned.fill(
              child: Image.asset(
                'assets/assetscard/cards/1.png',
                fit: BoxFit.contain,
              ),
            ),
          if (w2LastStageStars > 0)
            Positioned.fill(
              child: Image.asset(
                'assets/assetscard/cards/2.png',
                fit: BoxFit.contain,
              ),
            ),
          if (w3LastStageStars > 0)
            Positioned.fill(
              child: Image.asset(
                'assets/assetscard/cards/3.png',
                fit: BoxFit.contain,
              ),
            ),
          if (w4LastStageStars > 0)
            Positioned.fill(
              child: Image.asset(
                'assets/assetscard/cards/4.png',
                fit: BoxFit.contain,
              ),
            ),
          if (w5LastStageStars > 0)
            Positioned.fill(
              child: Image.asset(
                'assets/assetscard/cards/5.png',
                fit: BoxFit.contain,
              ),
            ),
          if (w6LastStageStars > 0)
            Positioned.fill(
              child: Image.asset(
                'assets/assetscard/cards/6.png',
                fit: BoxFit.contain,
              ),
            ),
          // Return button
          Positioned(
            top: size.height * 0.02,
            left: -size.width * 0.001,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CardScreen()),
                );
              },
              child: SizedBox(
                width: size.width * 0.08,
                height: size.width * 0.08,
                child: Image.asset(
                  'assets/assetscard/icons/return.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Title
          Positioned(
            top: size.height * 0.01,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'نظرة عامة على خريطة الجزائر',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}