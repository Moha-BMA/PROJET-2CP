import 'package:flutter/material.dart';
import 'package:chainage1/Settings/Settings.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'OpenedStageGroup2.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class StageScreen2 extends ConsumerStatefulWidget {
  const StageScreen2({super.key});

  @override
  ConsumerState<StageScreen2> createState() => _StageScreen2State();
}

class _StageScreen2State extends ConsumerState<StageScreen2> {
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
    int W2stage1 = prefs.getInt('W2_stage1_stars') ?? 0;
    int W2stage2 = prefs.getInt('W2_stage2_stars') ?? 0;
    int Swilaya2 = prefs.getInt('S_wilaya2') ?? 1;

    // Update the providers
    ref.read(w2Stage1StarsProvider.notifier).setStars(W2stage1);
    ref.read(w2Stage2StarsProvider.notifier).setStars(W2stage2);
    ref.read(wilaya2ProgressProvider.notifier).state = Swilaya2;

    // Update the global star count by adding Wilaya 2's stars


    // Check if any stars were earned from the jigsaw puzzle game
    // If so, update the progress to unlock next stage if needed
    if (W2stage1 > 0 && Swilaya2 < 2) {
      // Unlock stage 2 if player earned any stars in stage 1
      ref.read(wilaya2ProgressProvider.notifier).state = 2;
      prefs.setInt('S_wilaya2', 2);
    }

    // Check if any stars were earned from the flip card game
    if (W2stage2 > 0 && Swilaya2 < 3) {
      // Unlock stage 3 if player earned any stars in stage 2
      ref.read(wilaya2ProgressProvider.notifier).state = 3;
      prefs.setInt('S_wilaya2', 3);
    }

    // Award coins for new stars in stage 1
    int awardedStarsStage1 = prefs.getInt('W2_stage1_coins_awarded_stars') ?? 0;
    if (W2stage1 > awardedStarsStage1) {
      // Calculate new stars earned
      int newStars = W2stage1 - awardedStarsStage1;
      int coinsToAdd = newStars * 300; // 300 coins per new star
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      // Update the number of stars for which coins were awarded
      prefs.setInt('W2_stage1_coins_awarded_stars', W2stage1);
    }

    // Award coins for new stars in stage 2
    int awardedStarsStage2 = prefs.getInt('W2_stage2_coins_awarded_stars') ?? 0;
    if (W2stage2 > awardedStarsStage2) {
      // Calculate new stars earned
      int newStars = W2stage2 - awardedStarsStage2;
      int coinsToAdd = newStars * 300; // 300 coins per new star
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      // Update the number of stars for which coins were awarded
      prefs.setInt('W2_stage2_coins_awarded_stars', W2stage2);
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
    int W2stage1 = ref.watch(w2Stage1StarsProvider);
    int W2stage2 = ref.watch(w2Stage2StarsProvider);

    // Overall wilaya progress (unlocks stages)
    int Swilaya2 = ref.watch(wilaya2ProgressProvider);

    // Get total stars for display
    final totalStars = ref.watch(starsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/assetswilayas/wilaya2/Wilaya.png',
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
          OpenedStageGroup2(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight*0.058,
            offsetLeft: screenWidth*0.1009,
            text: '2',
            starstate: W2stage2,
            isOpen:  Swilaya2>1,
            stageNumber: 2,
          ),

          // Stage 2
          OpenedStageGroup2(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.17,
            offsetLeft: -screenWidth * 0.195,
            text: '1',
            starstate: W2stage1,
            isOpen: Swilaya2>0,
            stageNumber: 1,
          ),

          // Stage 3

        ],
      ),
    );
  }
}
final wilaya2ProgressProvider = StateProvider<int>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getInt('S_wilaya2') ?? 1; // Default to 1 to show at least first stage
});