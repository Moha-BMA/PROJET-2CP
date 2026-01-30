import 'package:flutter/material.dart';
import 'package:chainage1/Settings/Settings.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'OpenedStageGroup4.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class StageScreen4 extends ConsumerStatefulWidget {
  const StageScreen4({super.key});

  @override
  ConsumerState<StageScreen4> createState() => _StageScreen4State();
}

class _StageScreen4State extends ConsumerState<StageScreen4> {
  @override
  void initState() {
    super.initState();
    // Schedule the state updates for after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndUpdateProgress();
    });
  }

  // Move the logic for checking and updating progress out of the build method
  void _checkAndUpdateProgress() {
    final prefs = ref.read(sharedPreferencesProvider);

    // Get star counts and update the providers
    int W4stage1 = prefs.getInt('W4_stage1_stars') ?? 0;
    int W4stage2 = prefs.getInt('W4_stage2_stars') ?? 0;
    int Swilaya4 = prefs.getInt('S_wilaya4') ?? 1;

    // Update the providers
    ref.read(w4Stage1StarsProvider.notifier).setStars(W4stage1);
    ref.read(w4Stage2StarsProvider.notifier).setStars(W4stage2);
    ref.read(wilaya4ProgressProvider.notifier).state = Swilaya4;

    // Update the global star count by adding Wilaya 4's stars


    // Unlock next stage based on stars earned
    if (W4stage1 > 0 && Swilaya4 < 2) {
      ref.read(wilaya4ProgressProvider.notifier).state = 2;
      prefs.setInt('S_wilaya4', 2);
    }

    // Award coins for new stars in stage 1
    int awardedStarsStage1 = prefs.getInt('W4_stage1_coins_awarded_stars') ?? 0;
    if (W4stage1 > awardedStarsStage1) {
      int newStars = W4stage1 - awardedStarsStage1;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W4_stage1_coins_awarded_stars', W4stage1);
    }

    // Award coins for new stars in stage 2
    int awardedStarsStage2 = prefs.getInt('W4_stage2_coins_awarded_stars') ?? 0;
    if (W4stage2 > awardedStarsStage2) {
      int newStars = W4stage2 - awardedStarsStage2;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W4_stage2_coins_awarded_stars', W4stage2);
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    // Get SharedPreferences from provider (just for reading)
    final prefs = ref.watch(sharedPreferencesProvider);

    // Retrieve star states for each stage using our providers
    int w4stage1 = ref.watch(w4Stage1StarsProvider);
    int w4stage2 = ref.watch(w4Stage2StarsProvider);

    // Overall wilaya progress (unlocks stages)
    int Swilaya4 = ref.watch(wilaya4ProgressProvider);

    // Get total stars for display
    final totalStars = ref.watch(starsProvider);
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/assetswilayas/wilaya4/Wilaya.png',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
          ),

          // Back button
          Positioned(
            top: size.height * 0.04,
            left: size.width * 0.01,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  CardScreen()),
                );
              },
              child: SizedBox(
                width: size.width  * 0.08,
                height: size.width  * 0.08,
                child: Image.asset(
                  'assets/assetscard/icons/return.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),



          // Settings button
          Positioned(
            top: screenHeight * 0.02,
            left: screenWidth * 0.86,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
              child: SizedBox(
                width: screenWidth * 0.13,
                height: screenWidth * 0.1,
                child: Image.asset(
                  'assets/assetsMainPage/settings_icon.png',
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.15,
                ),
              ),
            ),
          ),

          // Stage 1
          OpenedStageGroup4(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.06,
            offsetLeft: screenWidth * 0.02,
            text: '1',
            starstate: w4stage1,
            isOpen: Swilaya4>0,
            stageNumber: 1,
          ),

          // Stage 2

          OpenedStageGroup4(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenWidth*0.168,
            offsetLeft: -screenHeight*0.16,
            text: '2',
            starstate: w4stage2,
            isOpen:Swilaya4>1,
            stageNumber: 2,
          ),

          // Stage 3

        ],
      ),
    );
  }
}
final wilaya4ProgressProvider = StateProvider<int>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getInt('S_wilaya4') ?? 1; // Default to 1 to show at least first stage
});