import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chainage1/Games/above8/w2/stage2/loading2.dart';
import 'package:chainage1/Games/above8/w2/stage2/Settings.dart';
import 'dart:math';
import 'dart:async';
import 'flipcard.dart';
import 'package:chainage1/screens/MainScreen.dart';
import 'package:chainage1/app_state.dart';
import 'package:chainage1/Wilayas_stages/above%208/w2/stage_screen2.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryGame extends ConsumerStatefulWidget {
  final int previousTimeInSeconds;

  const MemoryGame({Key? key, this.previousTimeInSeconds = 0}) : super(key: key);

  @override
  ConsumerState<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends ConsumerState<MemoryGame> with SingleTickerProviderStateMixin {
  late List<CardData> _cardList;
  int? _firstCardIndex;
  int? _secondCardIndex;
  bool _waitingForFlipBack = false;
  late List<bool> _cardsToDisappear;
  late List<bool> _matchedCards;
  int _cardsFlippingBack = 0;
  int _cardsDisappearing = 0;
  late Timer _timer;
  int _seconds = 0;
  int _previousTime = 0;
  int _totalTime = 0;
  int _moves = 0;
  bool _isTrophyContainerVisible = false;
  bool _isFirstNextPress = false;
  bool _showGameCompletion = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _initializeGame() {
    List<CardData> pairs = [
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/1.png',
          pairId: 1),
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/1.png',
          pairId: 1),
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/2.png',
          pairId: 2),
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/2.png',
          pairId: 2),
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/3.png',
          pairId: 3),
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/3.png',
          pairId: 3),
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/4.png',
          pairId: 4),
      CardData(
          frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png',
          backImage: 'assets/assetsgamesunderabove/above8/wilaya2/stage2/flipcard/4.png',
          pairId: 4),
    ];
    pairs.shuffle(Random());

    setState(() {
      _cardList = pairs;
      _matchedCards = List.filled(pairs.length, false);
      _cardsToDisappear = List.filled(pairs.length, false);
      _firstCardIndex = null;
      _secondCardIndex = null;
      _waitingForFlipBack = false;
      _cardsFlippingBack = 0;
      _cardsDisappearing = 0;
      _moves = 0;
      _showGameCompletion = false;
      _isTrophyContainerVisible = false;
    });
  }

  void _handleCardFlip(int index, int pairId) {
    if (_waitingForFlipBack) return;

    setState(() {
      if (_firstCardIndex == null) {
        _firstCardIndex = index;
      } else if (_secondCardIndex == null && index != _firstCardIndex) {
        _secondCardIndex = index;
        _moves++;

        if (_cardList[_firstCardIndex!].pairId == _cardList[index].pairId) {
          _cardsToDisappear[_firstCardIndex!] = true;
          _cardsToDisappear[index] = true;
          _cardsDisappearing = 2;
        } else {
          _waitingForFlipBack = true;
          _cardsFlippingBack = 2;
        }
      }
    });
  }

  void _onFlipBackComplete() {
    setState(() {
      _cardsFlippingBack--;
      if (_cardsFlippingBack <= 0) {
        _firstCardIndex = null;
        _secondCardIndex = null;
        _waitingForFlipBack = false;
      }
    });
  }

  void _onDisappearComplete() {
    setState(() {
      _cardsDisappearing--;

      if (_cardsDisappearing <= 0 && _firstCardIndex != null && _secondCardIndex != null) {
        _matchedCards[_firstCardIndex!] = true;
        _matchedCards[_secondCardIndex!] = true;

        _firstCardIndex = null;
        _secondCardIndex = null;

        if (!_matchedCards.contains(false)) {
          _timer.cancel();
          _totalTime = _previousTime + _seconds;

          _saveGameResults();

          if (_isFirstNextPress) {
            _isTrophyContainerVisible = true;
            _controller.forward(from: 0);
          } else {
            _showGameCompletion = true;
          }
        }
      }
    });
  }

  int _calculateStars() {
    if (_totalTime <= 35) {
      return 3;
    } else if (_totalTime <= 50) {
      return 2;
    } else {
      return 1;
    }
  }

  void _saveGameResults() {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final int earnedStars = _calculateStars();

      int previousStars = prefs.getInt('W2_stage2_stars') ?? 0;

      if (earnedStars > previousStars) {
        prefs.setInt('W2_stage2_stars', earnedStars);
        ref.read(w2Stage2StarsProvider.notifier).setStars(earnedStars);
        prefs.setBool('W2_stage2_completed', true);

        int currentProgress = prefs.getInt('S_wilaya2') ?? 1;
        if (currentProgress < 3 && earnedStars > 0) {
          prefs.setInt('S_wilaya2', 3);
          ref.read(wilaya2ProgressProvider.notifier).state = 3;
        }

        final starsNotifier = ref.read(starsProvider.notifier);
        starsNotifier.addStars(earnedStars - previousStars);

        print("Stage completion saved: Wilaya 2, Stage 2 - $earnedStars stars");
      } else {
        prefs.setBool('W2_stage2_completed', true);
      }

      prefs.setInt('FlipCard_time', _totalTime);
    } catch (e) {
      print("Error saving stage completion: $e");
    }
  }

  void _showGameOverDialog() {
    final int earnedStars = _calculateStars();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return Container(
                width: width * 0.35,
                height: height * 0.75,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/assetsgames/assetsPuzzle/award_template.png'),
                    fit: BoxFit.fill,
                  ),

                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: height * 0.3,
                      left: width * 0.09,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          'النجوم المكتسبة: $earnedStars',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontFamily: 'AQEEQSANSPRO-ExtraBold',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Positioned(
                      top: height * 0.39, // Adjusted to be below "النجوم المكتسبة"
                      left: width * 0.09,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          'الوقت المستغرق: ${_formatTime(_totalTime)}',
                          style: TextStyle(
                            fontFamily: 'AQEEQSANSPRO-ExtraBold',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: height * 0.17,
                      left: width * 0.0001,
                      child: Image.asset(
                        'assets/assetsgames/assetsPuzzle/star_gray.png',
                        width: width * 0.18,
                        height: height * 0.18,
                      ),
                    ),
                    Positioned(
                      top: height * 0.14,
                      left: width * 0.075,
                      child: Image.asset(
                        'assets/assetsgames/assetsPuzzle/star_gray.png',
                        width: width * 0.2,
                        height: height * 0.2,
                      ),
                    ),
                    Positioned(
                      top: height * 0.17,
                      left: width * 0.17,
                      child: Image.asset(
                        'assets/assetsgames/assetsPuzzle/star_gray.png',
                        width: width * 0.18,
                        height: height * 0.18,
                      ),
                    ),
                    if (earnedStars >= 1)
                      Positioned(
                        top: height * 0.17,
                        left: width * 0.0001,
                        child: Image.asset(
                          'assets/assetsgames/assetsPuzzle/star_yellow.png',
                          width: width * 0.18,
                          height: height * 0.18,
                        ),
                      ),
                    if (earnedStars >= 2)
                      Positioned(
                        top: height * 0.14,
                        left: width * 0.075,
                        child: Image.asset(
                          'assets/assetsgames/assetsPuzzle/star_yellow.png',
                          width: width * 0.2,
                          height: height * 0.2,
                        ),
                      ),
                    if (earnedStars >= 3)
                      Positioned(
                        top: height * 0.17,
                        left: width * 0.17,
                        child: Image.asset(
                          'assets/assetsgames/assetsPuzzle/star_yellow.png',
                          width: width * 0.18,
                          height: height * 0.18,
                        ),
                      ),
                    Positioned(
                      bottom: height * 0.1,
                      left: width * 0.01,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoadingScreen2()),
                          );
                        },
                        child: Image.asset(
                          'assets/assetsgames/assetsPuzzle/play_again_button.png',
                          width: width * 0.17,
                          height: height * 0.17,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: height * 0.1,
                      left: width * 0.175,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          startNextGame();
                        },
                        child: Image.asset(
                          'assets/assetsgames/assetsPuzzle/next_game_button.png',
                          width: width * 0.16,
                          height: height * 0.16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final isHighDensityScreen = screenSize.height > 800;

    double containerWidth = screenSize.width - 20;
    double containerHeight = screenSize.height - 10;
    double space = screenSize.width * (isHighDensityScreen ? 40 : 52) / 917;
    double space1 = screenSize.height * (isHighDensityScreen ? 34 : 44) / 412;

    final timerRight = isHighDensityScreen ? 10.0 : 0.0;
    final timerTop = screenSize.height * (isHighDensityScreen ? 0.4 : 0.43);
    final prevTimeTop = screenSize.height * (isHighDensityScreen ? 0.48 : 0.52);
    final totalTimeBottom = screenSize.height * (isHighDensityScreen ? 0.08 : 0.05);
    final movesTop = screenSize.height * (isHighDensityScreen ? 0.07 : 0.05);

    if (_showGameCompletion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGameOverDialog();
      });
    }

    return Scaffold(
        backgroundColor: Colors.transparent, // Set to transparent to allow image background
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/assetsgames/assetsPuzzle/puzzle_bg_kids.png'),
                  fit: BoxFit.cover, // Adjust fit as needed (cover, fill, etc.)
                ),
              ),
            ),
            Center(
              child: Container(
                width: containerWidth,
                height: containerHeight,
                decoration: const BoxDecoration(
                // Inner container background
                ),
                child: Stack(
                  children: [

                    GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        containerWidth * (125 / 917),
                        containerHeight * (isHighDensityScreen ? 60 : 56) / 412,
                        containerWidth * (125 / 917),
                        containerHeight * (isHighDensityScreen ? 60 : 56) / 412,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        crossAxisSpacing: space,
                        mainAxisSpacing: space1,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return FlipContainer(
                          cardData: _cardList[index],
                          onCardFlipped: (pairId) => _handleCardFlip(index, pairId),
                          canFlip: !_matchedCards[index] &&
                              !_waitingForFlipBack &&
                              !_cardsToDisappear[index],
                          shouldDisappear: _cardsToDisappear[index],
                          shouldFlipBack: _waitingForFlipBack &&
                              (index == _firstCardIndex || index == _secondCardIndex),
                          onFlipBackComplete: _onFlipBackComplete,
                          onDisappearComplete: _onDisappearComplete,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
         /* Positioned(
            right: timerRight,
            top: timerTop,
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(-2, 2),
                    blurRadius: 5,
                  ),
                ],
                border: Border.all(color: Color(0xFF522C0B), width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "الوقت",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF522C0B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(_seconds),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF258932),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: totalTimeBottom,
            left: screenSize.width * 0.5 - 80,
            child: Container(
              width: 160,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 2),
                    blurRadius: 5,
                  ),
                ],
                border: Border.all(color: Color(0xFF522C0B), width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "الوقت الكلي",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF522C0B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(_previousTime + _seconds),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF258932),
                    ),
                  ),
                ],
              ),
            ),
          ),*/
          Positioned(
            top: 18.5,
            right: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
              child: Image.asset(
                'assets/assetsMainPage/settings_icon.png',
                width: 90,
                height: 90,
              ),
            ),
          ),


          if (_isTrophyContainerVisible)
            GestureDetector(
              onTap: () async {
                final prefs = ref.read(sharedPreferencesProvider);
                await prefs.setBool('W2_stage2_next_pressed', true);
                setState(() {
                  _isTrophyContainerVisible = false;
                  _isFirstNextPress = false;
                  _showGameCompletion = true;
                });
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      painter: LightBeamPainter(),
                      child: Container(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Image.asset(
                                'assets/assetsTrophyspace/images/trophy2_col.png',
                                width: 200,
                                height: 300,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          'أحسنت! فُزت في هذه الولاية، وهذه مكافأتك',
                          style: GoogleFonts.cairo(
                            fontSize: MediaQuery.of(context).size.width * 0.015,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          'اضغط على الشاشة للمتابعة',
                          style: GoogleFonts.cairo(
                            fontSize: MediaQuery.of(context).size.width * 0.02,
                            fontWeight: FontWeight.normal,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeGame();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = ref.read(sharedPreferencesProvider);
      _previousTime = widget.previousTimeInSeconds;
      _isFirstNextPress = !(prefs.getBool('W2_stage2_next_pressed') ?? false);
      _startTimer();
    });
  }

  void startNextGame() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => StageScreen2()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}

class LightBeamPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    const radius = 80.0;
    const gradient = RadialGradient(
      colors: [
        Colors.white,
        Color.fromRGBO(255, 235, 59, 0.6),
        Colors.transparent,
      ],
      stops: [0.1, 0.5, 1.0],
    );
    final rect = Rect.fromCircle(center: center, radius: radius);
    final shader = gradient.createShader(rect);
    paint.shader = shader;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}