import 'package:flutter/material.dart';
import 'OpenedStageGroup5.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'package:chainage1/Settings/Settings.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class StageScreen5 extends ConsumerStatefulWidget {
  const StageScreen5({super.key});

  @override
  ConsumerState<StageScreen5> createState() => _StageScreen5State();
}

class _StageScreen5State extends ConsumerState<StageScreen5> {
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
    int W5stage1 = prefs.getInt('W5_stage1_stars') ?? 0;
    int W5stage2 = prefs.getInt('W5_stage2_stars') ?? 0;
    int W5stage3 = prefs.getInt('W5_stage3_stars') ?? 0;
    int W5stage4 = prefs.getInt('W5_stage4_stars') ?? 0;
    int Swilaya5 = prefs.getInt('S_wilaya5') ?? 1;

    // Update the providers
    ref.read(w5Stage1StarsProvider.notifier).setStars(W5stage1);
    ref.read(w5Stage2StarsProvider.notifier).setStars(W5stage2);
    ref.read(w5Stage3StarsProvider.notifier).setStars(W5stage3);
    ref.read(w5Stage4StarsProvider.notifier).setStars(W5stage4);
    ref.read(wilaya5ProgressProvider.notifier).state = Swilaya5;

    // Update the global star count by adding Wilaya 5's stars


    // Unlock next stages based on stars earned
    if (W5stage1 > 0 && Swilaya5 < 2) {
      ref.read(wilaya5ProgressProvider.notifier).state = 2;
      prefs.setInt('S_wilaya5', 2);
    }
    if (W5stage2 > 0 && Swilaya5 < 3) {
      ref.read(wilaya5ProgressProvider.notifier).state = 3;
      prefs.setInt('S_wilaya5', 3);
    }
    if (W5stage3 > 0 && Swilaya5 < 4) {
      ref.read(wilaya5ProgressProvider.notifier).state = 4;
      prefs.setInt('S_wilaya5', 4);
    }

    // Award coins for new stars in stage 1
    int awardedStarsStage1 = prefs.getInt('W5_stage1_coins_awarded_stars') ?? 0;
    if (W5stage1 > awardedStarsStage1) {
      int newStars = W5stage1 - awardedStarsStage1;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W5_stage1_coins_awarded_stars', W5stage1);
    }

    // Award coins for new stars in stage 2
    int awardedStarsStage2 = prefs.getInt('W5_stage2_coins_awarded_stars') ?? 0;
    if (W5stage2 > awardedStarsStage2) {
      int newStars = W5stage2 - awardedStarsStage2;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W5_stage2_coins_awarded_stars', W5stage2);
    }

    // Award coins for new stars in stage 3
    int awardedStarsStage3 = prefs.getInt('W5_stage3_coins_awarded_stars') ?? 0;
    if (W5stage3 > awardedStarsStage3) {
      int newStars = W5stage3 - awardedStarsStage3;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W5_stage3_coins_awarded_stars', W5stage3);
    }

    // Award coins for new stars in stage 4
    int awardedStarsStage4 = prefs.getInt('W5_stage4_coins_awarded_stars') ?? 0;
    if (W5stage4 > awardedStarsStage4) {
      int newStars = W5stage4 - awardedStarsStage4;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W5_stage4_coins_awarded_stars', W5stage4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get SharedPreferences from provider (just for reading)
    final prefs = ref.watch(sharedPreferencesProvider);

    // Retrieve star states for each stage using our providers
    int w5stage1 = ref.watch(w5Stage1StarsProvider);
    int w5stage2 = ref.watch(w5Stage2StarsProvider);
    int w5stage3 = ref.watch(w5Stage3StarsProvider);
    int w5stage4 = ref.watch(w5Stage4StarsProvider);

    // Overall wilaya progress (unlocks stages)
    int Swilaya5 = ref.watch(wilaya5ProgressProvider);

    // Get total stars for display
    final totalStars = ref.watch(starsProvider);
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/assetswilayas/wilaya5/Wilaya.png',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
          ),
//back button
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
          OpenedStageGroup5(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: 0,
            offsetLeft: 0,
            text: '2',
            starstate: w5stage2,
            isOpen: Swilaya5 > 1,
            stageNumber: 2,
          ),

          // Stage 2

          OpenedStageGroup5(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.187,
            offsetLeft: -screenWidth * 0.115,
            text: '3',
            starstate: w5stage3,
            isOpen: Swilaya5 > 2,
            stageNumber: 3,
          ),

          // Stage 3
          OpenedStageGroup5(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: -screenHeight * 0.185,
            offsetLeft: screenWidth * 0.0001,
            text: '1',
            starstate: w5stage1,
            isOpen: Swilaya5 > 0,
            stageNumber: 1,
          ),
          OpenedStageGroup5(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.375,
            offsetLeft: screenWidth * 0.01,
            text: '4',
            starstate: w5stage4,
            isOpen: Swilaya5 > 3,
            stageNumber: 4,
          ),
        ],
      ),
    );
  }
}
final wilaya5ProgressProvider = StateProvider<int>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getInt('S_wilaya5') ?? 1; // Default to 1 to show at least first stage
});