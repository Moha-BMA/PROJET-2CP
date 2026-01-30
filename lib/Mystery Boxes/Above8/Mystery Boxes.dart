import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chainage1/screens/MainScreen.dart';
import 'package:chainage1/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chainage1/MBGames/Above8/1/loading.dart' as a;
import 'package:chainage1/MBGames/Above8/2/loading.dart' as b;
import 'package:chainage1/MBGames/Above8/3/loading.dart' as c;
import 'package:chainage1/MBGames/Above8/4/loading.dart' as d;
import 'package:chainage1/MBGames/Above8/5/loading.dart' as e;
import 'package:chainage1/MBGames/Above8/6/loading.dart' as f;
import 'package:chainage1/MBGames/Above8/7/loading.dart' as g;
import 'package:chainage1/MBGames/Above8/8/loading.dart' as h;
import 'package:chainage1/MBGames/Above8/9/loading.dart' as i;
import 'package:chainage1/MBGames/Above8/10/loading.dart' as j;
import 'package:chainage1/MBGames/Above8/11/loading.dart' as k;
import 'package:chainage1/MBGames/Above8/12/loading.dart' as l;
import 'package:chainage1/MBGames/Above8/13/loading.dart' as m;
import 'package:chainage1/MBGames/Above8/14/loading.dart' as n;
import 'package:chainage1/MBGames/Above8/15/loading.dart' as o;
import 'package:chainage1/MBGames/Above8/16/loading.dart' as p;

class AffilationScreen extends ConsumerStatefulWidget {
  const AffilationScreen({super.key});

  @override
  AffilationScreenState createState() => AffilationScreenState();
}

class AffilationScreenState extends ConsumerState<AffilationScreen> {
  // Track purchased status for each box
  List<bool> isPurchased = List.generate(16, (index) => false);
  // Track played status for each box
  List<bool> isPlayed = List.generate(16, (index) => false);
  bool isLoading = true;

  // Store the destinations for each box
  final List<Widget Function(BuildContext)> boxDestinations = [
    // Box 0 (index 0)
        (context) => a.LoadingScreen(),
    // Box 1 (index 1)
        (context) => b.LoadingScreen(),
    // Box 2 (index 2)
        (context) => c.LoadingScreen(),
    // Box 3 (index 3)
        (context) => d.LoadingScreen(),
    // Box 4 (index 4)
        (context) => e.LoadingScreen(),
    // Box 5 (index 5)
        (context) => f.LoadingScreen(),
    // Box 6 (index 6)
        (context) => g.LoadingScreen(),
    // Box 7 (index 7)
        (context) => h.LoadingScreen(),
    // Box 8 (index 8)
        (context) => i.LoadingScreen(),
    // Box 9 (index 9)
        (context) => j.LoadingScreen(),
    // Box 10 (index 10)
        (context) => k.LoadingScreen(),
    // Box 11 (index 11)
        (context) => l.LoadingScreen(),
    // Box 12 (index 12)
        (context) => m.LoadingScreen(),
    // Box 13 (index 13)
        (context) => n.LoadingScreen(),
    // Box 14 (index 14)
        (context) => o.LoadingScreen(),
    // Box 15 (index 15)
        (context) => p.LoadingScreen(),
  ];

  // Keys for keeping track of purchases and played status across sessions - specific to Above8
  final String purchaseStateKey = 'boxPurchaseState_Above8';
  final String playedStateKey = 'boxPlayedState_Above8';

  @override
  void initState() {
    super.initState();
    _loadPurchaseState();
    _loadPlayedState();
  }

  // Load purchase state from SharedPreferences
  Future<void> _loadPurchaseState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPurchases = prefs.getStringList(purchaseStateKey);

      if (savedPurchases != null && savedPurchases.length == 16) {
        setState(() {
          isPurchased = savedPurchases.map((e) => e == 'true').toList();
        });
      }
    } catch (e) {
      print('Error loading purchase state: $e');
    }
  }

  // Load played state from SharedPreferences
  Future<void> _loadPlayedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPlayed = prefs.getStringList(playedStateKey);

      if (savedPlayed != null && savedPlayed.length == 16) {
        setState(() {
          isPlayed = savedPlayed.map((e) => e == 'true').toList();
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading played state: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Save purchase state whenever isPurchased changes
  Future<void> _savePurchaseState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        purchaseStateKey,
        isPurchased.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      print('Error saving purchase state: $e');
    }
  }

  // Save played state whenever isPlayed changes
  Future<void> _savePlayedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        playedStateKey,
        isPlayed.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      print('Error saving played state: $e');
    }
  }

  void purchaseBox(int index) {
    final coins = ref.read(coinsProvider);

    if (coins >= 300) {
      showConfirmPurchaseDialog(index);
    } else {
      showNotEnoughCoinsDialog();
    }
  }

  void showConfirmPurchaseDialog(int index) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Transparent background
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent dialog background
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return Center(
                child: Container(
                  width: width * 0.35,
                  height: height * 0.55,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/assetsAffilation/icons/ask.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Yes Button
                      Positioned(
                        top: height * 0.17,
                        left: -width * 0.1,
                        child: GestureDetector(
                          onTap: () async {
                            // Handle purchase logic
                            ref.read(coinsProvider.notifier).spendCoins(300);

                            setState(() {
                              isPurchased[index] = true;
                            });

                            // Save the updated purchase state
                            await _savePurchaseState();

                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/assetsAffilation/icons/yes.png',
                            width: width * 0.4,
                            height: height * 0.5,
                          ),
                        ),
                      ),
                      // No Button
                      Positioned(
                        top: height * 0.32,
                        left: width * 0.15,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Image.asset(
                            'assets/assetsAffilation/icons/no.png',
                            width: width * 0.2,
                            height: height * 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showNotEnoughCoinsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Transparent background
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent dialog background
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return Center(
                child: Container(
                  width: width * 0.35,
                  height: height * 0.55,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/assetsAffilation/icons/nomoney.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // OK Button
                      Positioned(
                        top: height * 0.28,
                        left: width * 0.105,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Image.asset(
                            'assets/assetsAffilation/icons/okey.png',
                            width: width * 0.15,
                            height: height * 0.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void navigateToBoxDestination(int index) {
    if (isPurchased[index]) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => boxDestinations[index](context),
        ),
      ).then((_) {
        // Mark the box as played after returning from the game
        setState(() {
          isPlayed[index] = true;
        });
        _savePlayedState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the values from providers
    final coins = ref.watch(coinsProvider);
    final isChildCategory = ref.watch(userCategoryProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Height of the coins bar area
    final double coinBarHeight = 70;

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/assetsMainPage/backgroundMainPage.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            // Scrollable content
            SingleChildScrollView(
              child: Column(
                children: [
                  // Space at the top to position below coin bar initially
                  SizedBox(height: coinBarHeight + 20),

                  // Grid of memory boxes with original layout
                  for (int row = 0; row < 4; row++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int col = 0; col < 4; col++)
                            buildBox(row * 4 + col),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Back button
            Positioned(
              top: screenHeight * 0.83,
              left: -screenWidth * 0.001,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Mainscreen()),
                  );
                },
                child: SizedBox(
                  width: screenWidth * 0.07,
                  height: screenWidth * 0.07,
                  child: Image.asset(
                    'assets/assetscard/icons/return.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            // Fixed coins bar at the top - using provider value
            Positioned(
              top: 10,
              left: 0,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/assetsAffilation/icons/coinsbar.png',
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.15,
                    fit: BoxFit.fill,
                  ),

                  // Centered coins text
                  Positioned.fill(
                    child: Align(
                      alignment: const Alignment(0.2, 0.1),
                      child: Text(
                        '$coins\$',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFEFC727),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Optionally, display a badge for child category
          ],
        ),
      ),
    );
  }

  Widget buildBox(int index) {
    // Using the original exact dimensions
    return GestureDetector(
      onTap: () {
        if (!isPurchased[index]) {
          purchaseBox(index);
        } else {
          navigateToBoxDestination(index);
        }
      },
      child: Stack(
        children: [
          Container(
            width: 160, // Original box width
            height: 180, // Original box height
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Question mark
                Text(
                  '?',
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFC727),
                  ),
                ),

                // Purchase or Enter button
                GestureDetector(
                  onTap: () {
                    if (isPurchased[index]) {
                      // Navigate to the specific destination for this box
                      navigateToBoxDestination(index);
                    } else {
                      // Show purchase dialog
                      purchaseBox(index);
                    }
                  },
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF705845),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isPurchased[index] ? 'أدخل' : '300\$',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isPurchased[index] ? Colors.white : const Color(0xFFEFC727),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Checkmark for played boxes
          if (isPlayed[index])
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(0xFF07FF24),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/assetsAffilation/icons/checkmark.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}