import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chainage1/app_state.dart';
import 'SecondScreen.dart';
import 'MainScreen.dart'; // Import MainScreen
import 'package:rive/rive.dart' as rive;
import 'dart:async';

class FirstScreen extends ConsumerStatefulWidget {
  const FirstScreen({super.key});

  @override
  FirstScreenState createState() => FirstScreenState();
}

class FirstScreenState extends ConsumerState<FirstScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () {
      // Check if the intro video has been viewed
      final hasViewedIntro = ref.read(hasViewedIntroVideoProvider);
      if (hasViewedIntro) {
        // Navigate to MainScreen if video has been viewed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  Mainscreen()),
        );
      } else {
        // Navigate to SecondScreen if video hasn't been viewed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SecondScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          rive.RiveAnimation.asset(
            'assets/assetsfirst5screens/loading_bar.riv',
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}