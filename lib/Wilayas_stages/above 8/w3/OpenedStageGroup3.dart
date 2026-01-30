// File 1: opened_stage_group1.dart
import 'package:chainage1/Games/above8/w3/stage1/loading1.dart';
import 'package:chainage1/Games/above8/w3/stage2/loading2.dart';
import 'package:flutter/material.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class OpenedStageGroup3 extends ConsumerStatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final double offsetTop;
  final double offsetLeft;
  final String text;
  final int starstate;
  final bool isOpen;
  final int stageNumber;

  const OpenedStageGroup3({
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
  ConsumerState<OpenedStageGroup3> createState() => _OpenedStageGroup3();
}

class _OpenedStageGroup3 extends ConsumerState<OpenedStageGroup3> {
  int _visibleStars = 0;

  @override
  void initState() {
    super.initState();
    _animateStars();
  }
  @override
  void didUpdateWidget(OpenedStageGroup3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.starstate != widget.starstate) {
      setState(() {
        _visibleStars = 0;
      });
      _animateStars();
    }
  }

  void _animateStars() async {
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
          switch (widget.stageNumber) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen1()),
              ).then((_) {
                final prefs = ref.read(sharedPreferencesProvider);
                int updatedStars = prefs.getInt('W3_stage1_stars') ?? widget.starstate;
                if (updatedStars != widget.starstate) {
                  ref.invalidate(w3Stage1StarsProvider);
                }
              });
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen2()),
              ).then((_) {
                final prefs = ref.read(sharedPreferencesProvider);
                int updatedStars = prefs.getInt('W3_stage2_stars') ?? widget.starstate;
                if (updatedStars != widget.starstate) {
                  ref.invalidate(w3Stage2StarsProvider);
                }
              });
              break;
            default:
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