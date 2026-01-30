// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chainage1/Games/above8/w6/stage1/loading1.dart';
import 'package:chainage1/Games/above8/w6/stage1/Settings.dart';
// Dart packages
import 'dart:math';
import 'dart:async';

// Local imports
import 'flipcard.dart';
import 'package:chainage1/card+gameplay/Card_Screen.dart';
import 'package:chainage1/app_state.dart';
import 'package:chainage1/Wilayas_stages/above 8/w6/stage_screen6.dart';

class MemoryGame extends ConsumerStatefulWidget {
  final int previousTimeInSeconds;

  // Constructor with optional parameter
  const MemoryGame({Key? key, this.previousTimeInSeconds = 0}) : super(key: key);

  @override
  ConsumerState<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends ConsumerState<MemoryGame> {
  // List of card data
  late List<CardData> _cardList;

  // Track the currently flipped cards
  int? _firstCardIndex;
  int? _secondCardIndex;

  // Track whether the game is waiting for cards to be flipped back
  bool _waitingForFlipBack = false;

  // Track cards that should disappear
  late List<bool> _cardsToDisappear;

  // List to track which cards have been matched
  late List<bool> _matchedCards;

  // Track cards waiting to flip back
  int _cardsFlippingBack = 0;

  // Track cards waiting to disappear
  int _cardsDisappearing = 0;

  // Timer variables
  late Timer _timer;
  int _seconds = 0;
  int _previousTime = 0;
  int _totalTime = 0;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();

    // Get previous time from QuizQ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = ref.read(sharedPreferencesProvider);
      // Use the passed time from QuizQ
      _previousTime = widget.previousTimeInSeconds;

      // Start the timer
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
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/1.jpg', pairId: 1),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/1.jpg', pairId: 1),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/2.jpg', pairId: 2),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/2.jpg', pairId: 2),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/3.jpg', pairId: 3),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/3.jpg', pairId: 3),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/4.jpg', pairId: 4),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsgamesunderabove/above8/wilaya6/stage1/flipcard/4.jpg', pairId: 4),
    ];

    // Shuffle the cards
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
    if (_waitingForFlipBack) return; // Don't allow new flips while waiting

    setState(() {
      if (_firstCardIndex == null) {
        // First card flipped
        _firstCardIndex = index;
      } else if (_secondCardIndex == null && index != _firstCardIndex) {
        // Second card flipped
        _secondCardIndex = index;
        // Increment moves counter when a pair is attempted
        _moves++;

        // Check if cards match
        if (_cardList[_firstCardIndex!].pairId == _cardList[index].pairId) {
          // Cards match, mark them to disappear
          _cardsToDisappear[_firstCardIndex!] = true;
          _cardsToDisappear[index] = true;
          _cardsDisappearing = 2;
        } else {
          // Cards don't match, prepare to flip them back
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

      // When both cards have disappeared, check if we need to update matched state
      if (_cardsDisappearing <= 0 && _firstCardIndex != null && _secondCardIndex != null) {
        _matchedCards[_firstCardIndex!] = true;
        _matchedCards[_secondCardIndex!] = true;

        // Reset selected cards
        _firstCardIndex = null;
        _secondCardIndex = null;

        // Check if all cards are matched
        if (!_matchedCards.contains(false)) {
          // All cards matched, game over!
          _timer.cancel(); // Stop the timer
          _totalTime = _previousTime + _seconds; // Calculate total time

          // Save stars and update progress
          _saveGameResults();

          Future.delayed(const Duration(milliseconds: 500), () {
            _showGameOverDialog();
          });
        }
      }
    });
  }

  int _calculateStars() {
    // Calculate stars based on total time (previous + current)
    // These thresholds can be adjusted based on your game's difficulty

    // For 8 cards (4 pairs), reasonable thresholds:
    if (_totalTime <= 35) {
      return 3; // Perfect game: fast
    } else if (_totalTime <= 50) {
      return 2; // Good game: decent time
    } else {
      return 1; // At least they completed it
    }
  }

  void _saveGameResults() {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final int earnedStars = _calculateStars();

      // Get previously earned stars, if any
      int previousStars = prefs.getInt('W6_stage1_stars') ?? 0;

      // Only update if the player earned more stars than before
      if (earnedStars > previousStars) {
        // Save stars earned for Wilaya 6, Stage 1
        prefs.setInt('W6_stage1_stars', earnedStars);

        // Update the provider state directly
        ref.read(w6Stage1StarsProvider.notifier).state = earnedStars;

        // Mark stage as completed
        prefs.setBool('W6_stage1_completed', true);

        // Update total wilaya progress if needed - only unlock stage 2 after completing stage 1
        int currentProgress = prefs.getInt('S_wilaya6') ?? 1;
        if (currentProgress < 2 && earnedStars > 0) {
          prefs.setInt('S_wilaya6', 2); // Unlock stage 2, not 3
          ref.read(wilaya6ProgressProvider.notifier).state = 2;
        }

        // Add stars to the global star count (only the difference)
        final starsNotifier = ref.read(starsProvider.notifier);
        starsNotifier.addStars(earnedStars - previousStars);

        print("Stage completion saved: Wilaya 6, Stage 1 - $earnedStars stars");
      } else {
        // Player didn't earn more stars than before, but the stage is still completed
        prefs.setBool('W6_stage1_completed', true);
      }

      // Save the total time for reference (for next stage)
      prefs.setInt('FlipCard_time', _totalTime);

      // Add coins for completing the stage if needed

    } catch (e) {
      print("Error saving stage completion: $e");
    }
  }
  void _showGameOverDialog() {
    final int earnedStars = _calculateStars();

    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final isHighDensityScreen = screenSize.height > 800; // For S20 Ultra and similar devices

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Full screen transparent container
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
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
                            fit: BoxFit.cover,
                          ),

                        ),
                        child: Stack(
                          children: [
                            // Victory Text


                            // Stars earned text
                            Positioned(
                              top: height * 0.3,
                              left: width * 0.1,


                              child: Text(
                                'النجوم المكتسبة: $earnedStars',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'AQEEQSANSPRO-ExtraBold',
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
                            // Gray Star Background Images
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

                            // Yellow Star Images (based on earned stars)
                            if (earnedStars >= 1) Positioned(
                              top: height * 0.17,
                              left: width * 0.0001,
                              child: Image.asset(
                                'assets/assetsgames/assetsPuzzle/star_yellow.png',
                                width: width * 0.18,
                                height: height * 0.18,
                              ),
                            ),
                            if (earnedStars >= 2) Positioned(
                              top: height * 0.14,
                              left: width * 0.075,
                              child: Image.asset(
                                'assets/assetsgames/assetsPuzzle/star_yellow.png',
                                width: width * 0.2,
                                height: height * 0.2,
                              ),
                            ),
                            if (earnedStars >= 3) Positioned(
                              top: height * 0.17,
                              left: width * 0.17,
                              child: Image.asset(
                                'assets/assetsgames/assetsPuzzle/star_yellow.png',
                                width: width * 0.18,
                                height: height * 0.18,
                              ),
                            ),

                            // Menu Button
                            Positioned(
                              bottom: height * 0.1,
                              left: width * 0.01,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoadingScreen1()),
                                  );
                                },
                                child: Image.asset(
                                  'assets/assetsgames/assetsPuzzle/play_again_button.png',
                                  width: width * 0.17,
                                  height: height * 0.17,
                                ),
                              ),
                            ),

                            // Next Game Button
                            Positioned(
                              bottom: height * 0.1,
                              left: width * 0.175,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => StageScreen6()),
                                  );
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
                ),
              ),
            ),
          ],
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
    // Adaptive sizing based on device screen
    final isHighDensityScreen = screenSize.height > 800; // For high-density screens like S20 Ultra

    double containerWidth = screenSize.width - 20;
    double containerHeight = screenSize.height - 10;
    double space = screenSize.width * (isHighDensityScreen ? 40 : 52) / 917;
    double space1 = screenSize.height * (isHighDensityScreen ? 34 : 44) / 412;

    // Adjust positions for better layout on high-density screens
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
          ),// Moves counter at the top

        ],
      ),
    );
  }
}