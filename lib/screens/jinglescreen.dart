import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app_state.dart';
import 'FirstScreen.dart';

class JingleScreen extends ConsumerStatefulWidget {
  const JingleScreen({super.key});

  @override
  ConsumerState<JingleScreen> createState() => _JingleScreenState();
}

class _JingleScreenState extends ConsumerState<JingleScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await _fadeController.forward(); // fade from black to visible

    // Load assets while splash is visible
    await _preloadAssets();

    // Hold for a second after assets load
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Transition to FirstScreen with fade
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const FirstScreen(),
          transitionDuration: const Duration(seconds: 2),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  Future<void> _preloadAssets() async {
    final prefs = ref.read(sharedPreferencesProvider);

    ref.read(userCategoryProvider.notifier);
    ref.read(coinsProvider.notifier);
    ref.read(starsProvider.notifier);

    // Preload images
    await Future.wait([
      precacheImage(const AssetImage('assets/assetsfirst5screens/img.png'), context),
      precacheImage(const AssetImage('assets/assetsfirst5screens/img1.png'), context),
      precacheImage(const AssetImage('assets/assetsfirst5screens/Frame 2.png'), context),
      rootBundle.load('assets/assetsfirst5screens/loading_bar.riv'), // Preload Rive
    ]);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Set image size relative to screen size, based on original dimensions (506x291)
    final double imageWidth = screenWidth * 0.5; // 50% of screen width
    final double imageHeight = (screenHeight / 506) * 291;
    return Scaffold(
      backgroundColor: Colors.black, // Start black, fade to red
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: const Color(0xFFFF0000), // Full red background
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/assetsfirst5screens/fennec.png',
                  width: imageWidth,
                  height: imageHeight,
                ),
                const SizedBox(height: 20),
                const Text(
                  'By Team 19',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
