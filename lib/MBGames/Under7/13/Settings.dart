import 'package:chainage1/Mystery%20Boxes/Under7/Mystery%20Boxes.dart';
import 'package:chainage1/screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:chainage1/MBGames/Under7/13/loading.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double startY = screenHeight * 0.02;
    double startX = screenWidth * 0.02;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),

          child: Stack(
            children: [
              Image.asset(
                'assets/assetsMainPage/backgroundMainPage.png',
                height: screenHeight,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: screenHeight * 0.28,
                right: screenWidth * 0.275,
                child: Image.asset(
                  "assets/assetssettings/Newsettings.png",
                  height: screenHeight * 0.45,
                  width: screenWidth * 0.45,
                ),
              ),

              Positioned(
                top: startY + screenHeight * 0.502,
                right: screenWidth * 0.408,
                child: ClipOval(
                  child: SizedBox(
                    width: screenWidth * 0.08, // Match image width
                    height: screenHeight * 0.08, // Match image height
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AffilationScreen()),
                        );
                      },
                      child: Image.asset(
                        "assets/assetssettings/home.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: screenHeight * 0.439,
                left: screenWidth * 0.462,
                child: ClipOval(
                  child: SizedBox(
                    width: screenWidth * 0.08, // Match image width
                    height: screenHeight * 0.08, // Match image height
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        "assets/assetssettings/stop.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: startY + screenHeight * 0.502,
                left: screenWidth * 0.4065,
                child: ClipOval(
                  child: SizedBox(
                    width: screenWidth * 0.085, // Match image width
                    height: screenHeight * 0.085, // Match image height
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoadingScreen()),
                        );
                      },
                      child: Image.asset(
                        "assets/assetssettings/playagain.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
