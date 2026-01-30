import 'package:flutter/material.dart';
import 'OpenedStageGroup1.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'package:chainage1/app_state.dart';
import 'package:chainage1/Settings/Settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class StageScreen1 extends ConsumerStatefulWidget {
  const StageScreen1({super.key});

  @override
  ConsumerState<StageScreen1> createState() => _StageScreen1State();
}

class _StageScreen1State extends ConsumerState<StageScreen1> {
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
    int W1stage1 = prefs.getInt('W1_stage1_stars') ?? 0;
    int W1stage2 = prefs.getInt('W1_stage2_stars') ?? 0;
    int W1stage3 = prefs.getInt('W1_stage3_stars') ?? 0;
    int Swilaya1 = prefs.getInt('S_wilaya1') ?? 1;

    // Update the providers
    ref.read(w1Stage1StarsProvider.notifier).setStars(W1stage1);
    ref.read(w1Stage2StarsProvider.notifier).setStars(W1stage2);
    ref.read(w1Stage3StarsProvider.notifier).setStars(W1stage3);
    ref.read(wilaya1ProgressProvider.notifier).state = Swilaya1;

    // Make sure the global star count is updated


    // Check if any stars were earned from the jigsaw puzzle game
    // If so, update the progress to unlock next stage if needed
    if (W1stage1 > 0 && Swilaya1 < 2) {
      // Unlock stage 2 if player earned any stars in stage 1
      ref.read(wilaya1ProgressProvider.notifier).state = 2;
      prefs.setInt('S_wilaya1', 2);
    }

    // Check if any stars were earned from the flip card game
    if (W1stage2 > 0 && Swilaya1 < 3) {
      // Unlock stage 3 if player earned any stars in stage 2
      ref.read(wilaya1ProgressProvider.notifier).state = 3;
      prefs.setInt('S_wilaya1', 3);
    }

    // Award coins for new stars in stage 1
    int awardedStarsStage1 = prefs.getInt('W1_stage1_coins_awarded_stars') ?? 0;
    if (W1stage1 > awardedStarsStage1) {
      // Calculate new stars earned
      int newStars = W1stage1 - awardedStarsStage1;
      int coinsToAdd = newStars * 300; // 300 coins per new star
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      // Update the number of stars for which coins were awarded
      prefs.setInt('W1_stage1_coins_awarded_stars', W1stage1);
    }

    // Award coins for new stars in stage 2
    int awardedStarsStage2 = prefs.getInt('W1_stage2_coins_awarded_stars') ?? 0;
    if (W1stage2 > awardedStarsStage2) {
      int newStars = W1stage2 - awardedStarsStage2;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W1_stage2_coins_awarded_stars', W1stage2);
    }

    // Award coins for new stars in stage 3
    int awardedStarsStage3 = prefs.getInt('W1_stage3_coins_awarded_stars') ?? 0;
    if (W1stage3 > awardedStarsStage3) {
      int newStars = W1stage3 - awardedStarsStage3;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W1_stage3_coins_awarded_stars', W1stage3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get SharedPreferences from provider (just for reading)
    final prefs = ref.watch(sharedPreferencesProvider);

    // Retrieve star states for each stage using our providers
    int W1stage1 = ref.watch(w1Stage1StarsProvider);
    int W1stage2 = ref.watch(w1Stage2StarsProvider);
    int W1stage3 = ref.watch(w1Stage3StarsProvider);

    // Overall wilaya progress (unlocks stages)
    int Swilaya1 = ref.watch(wilaya1ProgressProvider);

    // Get total stars for display
    final totalStars = ref.watch(starsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/assetswilayas/wilaya1/Wilaya.png',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
          ),

          // Back button
          Positioned(
            top: screenHeight * 0.04,
            left: screenWidth * 0.015,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  CardScreen()),
                );
              },
              child: SizedBox(
                width: screenWidth  * 0.07,
                height: screenHeight  * 0.13,
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
          OpenedStageGroup1(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.13,
            offsetLeft: screenWidth * 0.114,
            text: '1',
            starstate: W1stage1,
            isOpen: Swilaya1 > 0,
            stageNumber: 1,
          ),

          // Stage 2
          OpenedStageGroup1(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.36,
            offsetLeft: screenWidth * 0.027,
            text: '2',
            starstate: W1stage2,
            isOpen: Swilaya1 > 1,
            stageNumber: 2,
          ),

          // Stage 3
          OpenedStageGroup1(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.23,
            offsetLeft: -screenWidth * 0.1332,
            text: '3',
            starstate: W1stage3,
            isOpen: Swilaya1 > 2,
            stageNumber: 3,
          ),

        ],
      ),
    );
  }
}

// Add these providers to your app_state.dart file


// Provider to track overall Wilaya 1 progress
final wilaya1ProgressProvider = StateProvider<int>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getInt('S_wilaya1') ?? 1; // Default to 1 to show at least first stage
});