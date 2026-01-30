import 'package:chainage1/TrophySpace/TrophySpacePage.dart';
import 'package:chainage1/ProgressSpace/ProgressSpace.dart';
import 'package:chainage1/Settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'package:chainage1/Mystery%20Boxes/Under7/Mystery%20Boxes.dart' as kid;
import 'package:chainage1/Mystery%20Boxes/Above8/Mystery%20Boxes.dart' as ados;
import 'package:chainage1/app_state.dart';

class Mainscreen extends ConsumerWidget {
  Mainscreen({super.key});

  // Show exit confirmation dialog
  void _showExitDialog(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: screenWidth * 0.35,
          height: screenHeight * 0.55,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/assetsfirst5screens/exit.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Yes Button
              Positioned(
                top: screenHeight * 0.17,
                left: -screenWidth * 0.1,
                child: GestureDetector(
                  onTap: () {
                    // Exit the app
                    SystemNavigator.pop();
                  },
                  child: Image.asset(
                    'assets/assetsAffilation/icons/yes.png',
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.5,
                  ),
                ),
              ),
              // No Button
              Positioned(
                top: screenHeight * 0.32,
                left: screenWidth * 0.15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Image.asset(
                    'assets/assetsAffilation/icons/no.png',
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get state values from providers
    final coins = ref.watch(coinsProvider);
    final stars = ref.watch(starsProvider);
    final isChild = ref.watch(userCategoryProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Defining starting positions dynamically
    final double startX = screenWidth * 0.02;
    final double startY = screenHeight * 0.02;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/assetsMainPage/backgroundMainPage.png',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: startY + screenHeight * -0.00001,
              left: -startX + screenWidth * 0.01,
              child: Image.asset(
                'assets/assetsMainPage/algeria.png',
                width: screenWidth,
                height: screenHeight * 0.9,
              ),
            ),

            /* Positioned(
              right: screenWidth * 0.00,
              top: screenHeight * 0.00,
              bottom: screenHeight * 0.00,
              child: Container(
                width: screenWidth * 0.10,
                color: Color(0xFF996D3C),
              ),
            ),*/

            Positioned(
              top: 2 * startY,
              right: startX - screenWidth * 0.045,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgressSpacePage(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/assetsMainPage/profil_icon.png',
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.15,
                ),
              ),
            ),


            Positioned(
              top: 2 * startY,
              right: startX + screenWidth * 0.045,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>TrophySpacePage(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/assetsMainPage/trophies_icon.png',
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.15,
                ),
              ),
            ),

            // Choose which mystery box screen to show based on isChild value from provider
            Positioned(
              top: startY + screenHeight * 0.38,
              left: startX - screenWidth * 0.045,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      isChild
                          ? ados.AffilationScreen()
                          : kid.AffilationScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/assetsMainPage/tasks_icon2.png',
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.15,
                ),
              ),
            ),

            // Help icon modified to be exit button
            Positioned(
              top: 2 * startY,
              left: startX - screenWidth * 0.046,
              child: GestureDetector(
                onTap: () {
                  _showExitDialog(context, ref);
                },
                child: Image.asset(
                  'assets/assetsMainPage/exit.png',
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.15,
                ),
              ),
            ),

            Positioned(
              top: startY + screenHeight * 0.65,
              right: -2 * startX + screenWidth * 0.1,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CardScreen()),
                  );
                },
                child: Image.asset(
                  'assets/assetsMainPage/start.png',
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.25,
                ),
              ),
            ),

            Positioned(
              top: startY - screenHeight * 0.017,
              left: startX + screenWidth * 0.1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/assetsMainPage/star.png",
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.12,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: const Alignment(0.15,-0.2),
                      child: Text(
                        '$stars',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEFC727),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: startY - screenHeight * 0.017,
              left: -startX + screenWidth * 0.32,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/assetsMainPage/coin.png",
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.12,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: const Alignment(0.15,-0.2),
                      child: Text(
                        '$coins\$',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEFC727),
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