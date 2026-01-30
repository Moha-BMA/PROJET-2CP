import 'package:chainage1/Games/above8/w1/stage1/loading1.dart';
import 'package:chainage1/Games/above8/w1/stage2/loading2.dart';
import 'package:chainage1/Games/above8/w1/stage3/loading3.dart';
import 'package:flutter/material.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenedStageGroup1 extends ConsumerStatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final double offsetTop;
  final double offsetLeft;
  final String text;
  final int starstate;
  final bool isOpen;
  final int stageNumber;

  const OpenedStageGroup1({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.offsetTop,
    required this.offsetLeft,
    required this.text,
    required this.starstate,
    required this.isOpen,
    required this.stageNumber,
  }) : super(key: key);

  @override
  ConsumerState<OpenedStageGroup1> createState() => _OpenedStageGroup1();
}

class _OpenedStageGroup1 extends ConsumerState<OpenedStageGroup1> {
  int _visibleStars = 0;

  @override
  void initState() {
    super.initState();
    _animateStars();
  }
  @override
  void didUpdateWidget(OpenedStageGroup1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.starstate != widget.starstate) {
      setState(() {
        _visibleStars = 0;
      });
      _animateStars();
    }
  }
  void _animateStars() async {
    // Reset visible stars first
    if (mounted) {
      setState(() {
        _visibleStars = 0;
      });
    }

    // Then animate them appearing one by one
    for (int i = 0; i < widget.starstate && i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _visibleStars = i + 1;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (widget.isOpen) {
      return GestureDetector(
        onTap: () {
          // Navigate to the appropriate screen based on stage number
          switch (widget.stageNumber) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen1()),
              ).then((_) {
                // When returning from the game, read the latest star count
                // This will trigger didUpdateWidget if the star count changed
                final prefs = ref.read(sharedPreferencesProvider);
                int updatedStars = prefs.getInt('W1_stage1_stars') ?? widget.starstate;
                if (updatedStars != widget.starstate) {
                  // Force a rebuild of the parent widget
                  ref.invalidate(w1Stage1StarsProvider);
                }
              });
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen2()),
              ).then((_) {
                // Similar logic for stage 2
                final prefs = ref.read(sharedPreferencesProvider);
                int updatedStars = prefs.getInt('W1_stage2_stars') ?? widget.starstate;
                if (updatedStars != widget.starstate) {
                  // Force a rebuild of the parent widget if needed
                  ref.invalidate(w1Stage2StarsProvider);
                }
              });
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen3()),
              ).then((_) {
                // Similar logic for stage 3
                final prefs = ref.read(sharedPreferencesProvider);
                int updatedStars = prefs.getInt('W1_stage3_stars') ?? widget.starstate;
                if (updatedStars != widget.starstate) {
                  // Force a rebuild of the parent widget if needed
                  ref.invalidate(w1Stage3StarsProvider);
                }
              });
              break;
            default:
            // Default case (optional)
              break;
          }
        },
        child: _buildStageContent(),
      );
    } else {
      return _buildStageContent();
    }
  }

  Widget _buildStageContent() {
    return Stack(
      children: [
        Positioned(
          top: widget.screenHeight * 0.21 + widget.offsetTop,
          left: widget.screenWidth * 0.5 + widget.offsetLeft,
          right: widget.screenWidth * 0.42 - widget.offsetLeft,
          bottom: widget.screenHeight * 0.45 - widget.offsetTop,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                widget.isOpen
                    ? 'assets/assetswilayas/Open.png'
                    : 'assets/assetswilayas/Close.png',
                width: widget.screenWidth * 0.5,
                height: widget.screenHeight * 0.5,
              ),
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_visibleStars > 0)
          Positioned(
            top: widget.screenHeight * 0.14 + widget.offsetTop,
            left: widget.screenWidth * 0.49 + widget.offsetLeft,
            right: widget.screenWidth * 0.47 - widget.offsetLeft,
            bottom: widget.screenHeight * 0.47 - widget.offsetTop,
            child: Image.asset('assets/assetswilayas/star1.png'),
          ),
        if (_visibleStars > 1)
          Positioned(
            top: widget.screenHeight * 0.1 + widget.offsetTop,
            left: widget.screenWidth * 0.52 + widget.offsetLeft,
            right: widget.screenWidth * 0.44 - widget.offsetLeft,
            bottom: widget.screenHeight * 0.47 - widget.offsetTop,
            child: Image.asset('assets/assetswilayas/star2.png'),
          ),
        if (_visibleStars > 2)
          Positioned(
            top: widget.screenHeight * 0.14 + widget.offsetTop,
            left: widget.screenWidth * 0.55 + widget.offsetLeft,
            right: widget.screenWidth * 0.41 - widget.offsetLeft,
            bottom: widget.screenHeight * 0.47 - widget.offsetTop,
            child: Image.asset('assets/assetswilayas/star3.png'),
          ),
      ],
    );
  }
}