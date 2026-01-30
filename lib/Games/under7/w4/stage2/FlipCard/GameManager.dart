import 'package:flutter/material.dart';
import 'dart:math';
import 'flipcard.dart';
import 'package:chainage1/Games/under7/w4/stage2/Puzzle/JigsawPuzzleScreen.dart';
import 'dart:async';
import 'package:chainage1/Wilayas_stages/under 7/w4/stage_screen4.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chainage1/Games/under7/w4/stage2/Settings.dart';

class MemoryGame extends ConsumerStatefulWidget {
  final int previousTimeInSeconds;

  const MemoryGame({Key? key, this.previousTimeInSeconds = 0}) : super(key: key);

  @override
  ConsumerState<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends ConsumerState<MemoryGame> {
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

  @override
  void initState() {
    super.initState();
    _initializeGame();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = ref.read(sharedPreferencesProvider);
      _previousTime = widget.previousTimeInSeconds;
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _initializeGame() {
    // Create pairs of card data - 4 pairs for 8 cards total
    List<CardData> pairs = [
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/1.jpg', pairId: 1),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/1.jpg', pairId: 1),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/2.jpg', pairId: 2),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/2.jpg', pairId: 2),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/3.png', pairId: 3),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/3.png', pairId: 3),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/4.jpg', pairId: 4),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/under7/wilaya4/stage2/flipcard/4.jpg', pairId: 4),
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
          Future.delayed(const Duration(milliseconds: 500), () {
            _showGameOverDialog();
          });
        }
      }
    });
  }

  int _calculateStars() {
    if (_totalTime <= 40) {
      return 3;
    } else if (_totalTime <= 60) {
      return 2;
    } else {
      return 1;
    }
  }


  void _showGameOverDialog() {
    final int earnedStars = _calculateStars();
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              // Use both methods to load the background
              image: DecorationImage(
                image: AssetImage('assets/images/win_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.05,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '!لقد ربحت',
                  style: TextStyle(
                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    shadows: [
                      Shadow(
                        offset: const Offset(5, 5),
                        blurRadius: 3.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  'الوقت المستغرق: $_totalTime',
                  style: TextStyle(
                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JigsawPuzzleScreen(
                            previousTimeInSeconds: _totalTime,
                          ),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  child: const Text('متابعة'),
                ),
              ],
            ),
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


        ],
      ),
    );
  }
}