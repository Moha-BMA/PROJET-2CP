import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chainage1/screens/MainScreen.dart';
import 'package:chainage1/app_state.dart';


// ---------------- TrophySpacePage ----------------
class TrophySpacePage extends ConsumerWidget {
  const TrophySpacePage({super.key});

  // Trophy data with assets and messages
  static const List<Map<String, dynamic>> trophyTemplates = [
    {
      "name": "الولاية 1",
      "colorAsset": "assets/assetsTrophyspace/images/trophy1_col.png",
      "lockedAsset": "assets/assetsTrophyspace/images/trophy1_black.png",
      "unlockedMessage": "ألفُ مَبْرُوك! لقد نِلْتَ هذا الكَأْسَ بجدارة.",
      "lockedMessage": "لم تحصل بعد على هذا الكأس. أكمل جميع مراحل الولاية 1 لتحصل عليه."
    },
    {
      "name": "الولاية 2",
      "colorAsset": "assets/assetsTrophyspace/images/trophy2_col.png",
      "lockedAsset": "assets/assetsTrophyspace/images/trophy2_black.png",
      "unlockedMessage": "ألفُ مَبْرُوك! لقد نِلْتَ هذا الكَأْسَ بجدارة.",
      "lockedMessage": "لم تحصل بعد على هذا الكأس. أكمل جميع مراحل الولاية 2 لتحصل عليه."
    },
    {
      "name": "الولاية 3",
      "colorAsset": "assets/assetsTrophyspace/images/trophy3_col.png",
      "lockedAsset": "assets/assetsTrophyspace/images/trophy3_black.png",
      "unlockedMessage": "ألفُ مَبْرُوك! لقد نِلْتَ هذا الكَأْسَ بجدارة.",
      "lockedMessage": "لم تحصل بعد على هذا الكأس. أكمل جميع مراحل الولاية 3 لتحصل عليه."
    },
    {
      "name": "الولاية 4",
      "colorAsset": "assets/assetsTrophyspace/images/trophy4_col.png",
      "lockedAsset": "assets/assetsTrophyspace/images/trophy4_black.png",
      "unlockedMessage": "ألفُ مَبْرُوك! لقد نِلْتَ هذا الكَأْسَ بجدارة.",
      "lockedMessage": "لم تحصل بعد على هذا الكأس. أكمل جميع مراحل الولاية 4 لتحصل عليه."
    },
    {
      "name": "الولاية 5",
      "colorAsset": "assets/assetsTrophyspace/images/trophy5_col.png",
      "lockedAsset": "assets/assetsTrophyspace/images/trophy5_black.png",
      "unlockedMessage": "ألفُ مَبْرُوك! لقد نِلْتَ هذا الكَأْسَ بجدارة.",
      "lockedMessage": "لم تحصل بعد على هذا الكأس. أكمل جميع مراحل الولاية 5 لتحصل عليه."
    },
    {
      "name": "الولاية 6",
      "colorAsset": "assets/assetsTrophyspace/images/trophy6_col.png",
      "lockedAsset": "assets/assetsTrophyspace/images/trophy6_black.png",
      "unlockedMessage": "ألفُ مَبْرُوك! لقد نِلْتَ هذا الكَأْسَ بجدارة.",
      "lockedMessage": "لم تحصل بعد على هذا الكأس. أكمل جميع مراحل الولاية 6 لتحصل عليه."
    },
  ];

  // Map wilayas to their last stage providers
  static final List<StateNotifierProvider<StateNotifier<int>, int>> lastStageProviders = [
    w1Stage3StarsProvider, // Wilaya 1, last stage: Stage 3
    w2Stage2StarsProvider, // Wilaya 2, last stage: Stage 2
    w3Stage2StarsProvider, // Wilaya 3, last stage: Stage 2
    w4Stage2StarsProvider, // Wilaya 4, last stage: Stage 2
    w5Stage4StarsProvider, // Wilaya 5, last stage: Stage 4
    w6Stage3StarsProvider, // Wilaya 6, last stage: Stage 3
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final bH = size.height * 0.4;
    final bW = size.width * 0.42;
    final bTop = size.height * -0.1;
    final bLeft = size.width * 0.30;
    final txtLeft = size.width * 0.355;
    final txtTop = size.height * -0.007;

    // Build dynamic trophies list by checking stars for the last stage
    final trophies = trophyTemplates.asMap().entries.map((entry) {
      final index = entry.key;
      final template = entry.value;
      final stars = ref.watch(lastStageProviders[index]);
      return {
        ...template,
        'isUnlocked': stars > 0, // Unlock if last stage has stars > 0
      };
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(bTop + bH),
        child: Stack(
          children: [
            // Wooden banner
            Positioned(
              left: bLeft,
              top: bTop,
              width: bW,
              height: bH,
              child: Image.asset(
                'assets/assetsTrophyspace/images/banner.png',
                fit: BoxFit.cover,
              ),
            ),
            // Title text
            Positioned(
              left: txtLeft,
              top: txtTop,
              child: Text(
                'غرفة الكؤوس',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.1,
                  shadows: [
                    Shadow(
                      offset: const Offset(5, 5),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ],
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Full-screen background
          Positioned.fill(
            child: Image.asset(
              'assets/assetsTrophyspace/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Centered horizontally-scrollable row of trophy boxes
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: trophies.map((t) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildTrophyBox(context, t),
                  );
                }).toList(),
              ),
            ),
          ),
          // Return button
          Positioned(
            top: screenHeight * 0.83,
            left: -screenWidth * 0.001,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  Mainscreen()),
                );
              },
              child: SizedBox(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                child: Image.asset(
                  'assets/assetsProgressspace/images/return.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrophyBox(BuildContext context, Map<String, dynamic> t) {
    final asset = t['isUnlocked'] ? t['colorAsset'] : t['lockedAsset'];
    return GestureDetector(
      onTap: () => _showTrophyDialog(context, t),
      child: Container(
        width: 220,
        height: 270,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(asset, width: 220, height: 200, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              t['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showTrophyDialog(BuildContext context, Map<String, dynamic> t) {
    final asset = t['isUnlocked'] ? t['colorAsset'] : t['lockedAsset'];
    final message = t['isUnlocked'] ? t['unlockedMessage'] : t['lockedMessage'];

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Stack(
          children: [
            // Main content box
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    t['name'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Trophy image
                  Image.asset(asset, width: 150, height: 150, fit: BoxFit.contain),
                  const SizedBox(height: 16),
                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(fontSize: 15),
                  ),
                ],
              ),
            ),
            // Close button
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset(
                  'assets/assetsTrophyspace/images/close_x.png',
                  width: 28,
                  height: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}