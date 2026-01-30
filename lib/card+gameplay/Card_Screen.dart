import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chainage1/screens/MainScreen.dart';
import 'package:chainage1/card+gameplay/CardProgress.dart';
import 'package:chainage1/Wilayas_stages/above 8/w1/stage_screen1.dart' as above1;
import 'package:chainage1/Wilayas_stages/above 8/w2/stage_screen2.dart' as above2;
import 'package:chainage1/Wilayas_stages/above 8/w3/stage_screen3.dart' as above3;
import 'package:chainage1/Wilayas_stages/above 8/w4/stage_screen4.dart' as above4;
import 'package:chainage1/Wilayas_stages/above 8/w5/stage_screen5.dart' as above5;
import 'package:chainage1/Wilayas_stages/above 8/w6/stage_screen6.dart' as above6;
import 'package:chainage1/Wilayas_stages/under 7/w1/stage_screen1.dart' as under1;
import 'package:chainage1/Wilayas_stages/under 7/w2/stage_screen2.dart' as under2;
import 'package:chainage1/Wilayas_stages/under 7/w3/stage_screen3.dart' as under3;
import 'package:chainage1/Wilayas_stages/under 7/w4/stage_screen4.dart' as under4;
import 'package:chainage1/Wilayas_stages/under 7/w5/stage_screen5.dart' as under5;
import 'package:chainage1/Wilayas_stages/under 7/w6/stage_screen6.dart' as under6;
import 'package:chainage1/app_state.dart';

class CardScreen extends ConsumerStatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends ConsumerState<CardScreen> {
  int currentIndex = 0;
  int bgIndex = 0;

  final List<String> backgrounds = [
    'assets/assetscard/icons/bg1.png',
    // add more backgrounds here
  ];

  final List<WilayaDef> aboveDefs = List.generate(6, (i) => WilayaDef(
    id: i + 1,
    label: 'الولاية ${i + 1}',
    cardAsset: 'assets/assetscard/cards/card_w${i + 1}.png',
    screen: () {
      switch (i + 1) {
        case 1:
          return const above1.StageScreen1();
        case 2:
          return const above2.StageScreen2();
        case 3:
          return const above3.StageScreen3();
        case 4:
          return const above4.StageScreen4();
        case 5:
          return const above5.StageScreen5();
        default:
          return const above6.StageScreen6();
      }
    },
  ));
  final List<WilayaDef> underDefs = List.generate(6, (i) => WilayaDef(
    id: i + 1,
    label: 'الولاية ${i + 1}',
    cardAsset: 'assets/assetscard/cards/card_w${i + 1}.png',
    screen: () {
      switch (i + 1) {
        case 1:
          return const under1.StageScreen1();
        case 2:
          return const under2.StageScreen2();
        case 3:
          return const under3.StageScreen3();
        case 4:
          return const under4.StageScreen4();
        case 5:
          return const under5.StageScreen5();
        default:
          return const under6.StageScreen6();
      }
    },
  ));

  void _goNext(int max) {
    if (currentIndex < max - 1) setState(() => currentIndex++);
  }

  void _goPrev() {
    if (currentIndex > 0) setState(() => currentIndex--);
  }

  void _changeBackground() {
    setState(() => bgIndex = (bgIndex + 1) % backgrounds.length);
  }
  /*void _showAlgeriaCard() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Image.asset(
          'assets/assetscard/cards/algeria_card.png', // replace with your Algerian card asset
          fit: BoxFit.contain,
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isChild = ref.watch(userCategoryProvider);
    final defs = isChild ? aboveDefs : underDefs;
    final current = defs[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic background
          Image.asset(
            backgrounds[bgIndex],
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),

          // Top bar: back, bg change, dropdown
          Positioned(
            top: size.height * 0.02,
            left: -size.width * 0.001,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  Mainscreen()),
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
          Positioned(
            top: size.height * 0.22,
            left: -size.width * 0.001,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  CardProgress()),
                );
              },
              child: SizedBox(
                width: size.width * 0.08,
                height: size.width * 0.08,
                child: Image.asset('assets/assetscard/icons/info.png'), // replace with your button asset
              ),
            ),
          ),

          // Wilaya card
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => current.screen()),
              ),
              child: Image.asset(
                current.cardAsset,
                width: size.width * 0.2,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Label
          Positioned(
            bottom: size.height * 0.01,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                current.label,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.05,
                  shadows: [Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black54)],
                  color: Colors.black,
                ),

              ),
            ),
          ),
          Positioned(
            top: size.height * 0.01,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '! اختَر الولاية التي تريد استكشافها',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04,
                  shadows: [Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black54)],
                  color: Colors.green,
                ),

              ),
            ),
          ),


          // Prev button
          if (currentIndex > 0)
            Positioned(
              bottom: size.height * 0.08,
              left: size.width * 0.04,
              child: IconButton(
                iconSize: size.width * 0.1,
                icon: Image.asset('assets/assetscard/icons/prev.png'),
                onPressed: _goPrev,
              ),
            ),

          // Next button
          if (currentIndex < defs.length - 1)
            Positioned(
              bottom: size.height * 0.08,
              right: size.width * 0.04,
              child: IconButton(
                iconSize: size.width * 0.1,
                icon: Image.asset('assets/assetscard/icons/next.png'),
                onPressed: () => _goNext(defs.length),
              ),
            ),
        ],
      ),
    );
  }
}

class WilayaDef {
  final int id;
  final String label;
  final String cardAsset;
  final Widget Function() screen;
  WilayaDef({
    required this.id,
    required this.label,
    required this.cardAsset,
    required this.screen,
  });
}
