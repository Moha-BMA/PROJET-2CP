import 'package:flutter/material.dart';
import 'OpenedStageGroup6.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'package:chainage1/Settings/Settings.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class StageScreen6 extends ConsumerStatefulWidget {
  const StageScreen6({super.key});

  @override
  ConsumerState<StageScreen6> createState() => _StageScreen6State();
}

class _StageScreen6State extends ConsumerState<StageScreen6> {
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
    int W6stage1 = prefs.getInt('W6_stage1_stars') ?? 0;
    int W6stage2 = prefs.getInt('W6_stage2_stars') ?? 0;
    int W6stage3 = prefs.getInt('W6_stage3_stars') ?? 0;
    int Swilaya6 = prefs.getInt('S_wilaya6') ?? 1;

    // Update the providers
    ref.read(w6Stage1StarsProvider.notifier).setStars(W6stage1);
    ref.read(w6Stage2StarsProvider.notifier).setStars(W6stage2);
    ref.read(w6Stage3StarsProvider.notifier).setStars(W6stage3);
    ref.read(wilaya6ProgressProvider.notifier).state = Swilaya6;

    // Update the global star count by adding Wilaya 6's stars


    // Unlock next stages based on stars earned
    if (W6stage1 > 0 && Swilaya6 < 2) {
      ref.read(wilaya6ProgressProvider.notifier).state = 2;
      prefs.setInt('S_wilaya6', 2);
    }
    if (W6stage2 > 0 && Swilaya6 < 3) {
      ref.read(wilaya6ProgressProvider.notifier).state = 3;
      prefs.setInt('S_wilaya6', 3);
    }

    // Award coins for new stars in stage 1
    int awardedStarsStage1 = prefs.getInt('W6_stage1_coins_awarded_stars') ?? 0;
    if (W6stage1 > awardedStarsStage1) {
      int newStars = W6stage1 - awardedStarsStage1;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W6_stage1_coins_awarded_stars', W6stage1);
    }

    // Award coins for new stars in stage 2
    int awardedStarsStage2 = prefs.getInt('W6_stage2_coins_awarded_stars') ?? 0;
    if (W6stage2 > awardedStarsStage2) {
      int newStars = W6stage2 - awardedStarsStage2;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W6_stage2_coins_awarded_stars', W6stage2);
    }

    // Award coins for new stars in stage 3
    int awardedStarsStage3 = prefs.getInt('W6_stage3_coins_awarded_stars') ?? 0;
    if (W6stage3 > awardedStarsStage3) {
      int newStars = W6stage3 - awardedStarsStage3;
      int coinsToAdd = newStars * 300;
      ref.read(coinsProvider.notifier).addCoins(coinsToAdd);
      prefs.setInt('W6_stage3_coins_awarded_stars', W6stage3);
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Get SharedPreferences from provider (just for reading)
    final prefs = ref.watch(sharedPreferencesProvider);

    // Retrieve star states for each stage using our providers
    int w6stage1 = ref.watch(w6Stage1StarsProvider);
    int w6stage2 = ref.watch(w6Stage2StarsProvider);
    int w6stage3 = ref.watch(w6Stage3StarsProvider);

    // Overall wilaya progress (unlocks stages)
    int Swilaya6 = ref.watch(wilaya6ProgressProvider);

    // Get total stars for display
    final totalStars = ref.watch(starsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/assetswilayas/wilaya6/Wilaya.png',
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
          OpenedStageGroup6(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight*0.074,
            offsetLeft: -screenWidth*0.0599,
            text: '2',
            starstate: w6stage2,
            isOpen: Swilaya6 > 1,
            stageNumber: 2,
          ),

          // Stage 2
          OpenedStageGroup6(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: screenHeight * 0.4455,
            offsetLeft: screenWidth * 0.0005,
            text: '3',
            starstate: w6stage3,
            isOpen: Swilaya6>2,
            stageNumber: 3,
          ),

          // Stage 3
          OpenedStageGroup6(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            offsetTop: -screenHeight * 0.03,
            offsetLeft: screenWidth * 0.0134,
            text: '1',
            starstate: w6stage1,
            isOpen: Swilaya6>0,
            stageNumber: 1,
          ),
        ],
      ),
    );
  }
}
final wilaya6ProgressProvider = StateProvider<int>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getInt('S_wilaya6') ?? 1; // Default to 1 to show at least first stage
});