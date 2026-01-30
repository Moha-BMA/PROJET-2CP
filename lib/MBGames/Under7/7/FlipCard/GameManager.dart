import 'package:flutter/material.dart';
import 'dart:math';
import 'flipcard.dart';
import 'package:chainage1/Mystery%20Boxes/Under7/Mystery%20Boxes.dart';
import 'package:chainage1/MBGames/Under7/7/Settings.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
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

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Create pairs of card data - 4 pairs for 8 cards total
    List<CardData> pairs = [
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/1.png', pairId: 1),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/1.png', pairId: 1),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/2.png', pairId: 2),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/2.png', pairId: 2),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/3.png', pairId: 3),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/3.png', pairId: 3),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/4.png', pairId: 4),
      CardData(frontImage: 'assets/assetsgames/assetsFlipCard/icons/fhead.png', backImage: 'assets/assetsMBflipcard/Q7/4.png', pairId: 4),
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
          Future.delayed(const Duration(milliseconds: 500), () {
            _showGameOverDialog();
          });
        }
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black54.withOpacity(0.6),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05,
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/win_background.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
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


                        // Display total time if there's previous time


                        SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Space below the text

                        // Continue Button (Navigates to JigsawPuzzleScreen with accumulated time)
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Future.delayed(const Duration(milliseconds: 200), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AffilationScreen(

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
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double containerWidth = screenSize.width - 20;
    double containerHeight = screenSize.height - 10;
    double space = screenSize.width * (52 / 917);
    double space1 = screenSize.height * (44 / 412);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/assetsgames/assetsPuzzle/puzzle_bg_kids.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: containerWidth,
                height: containerHeight,

                child: Stack(
                  children: [
                    // Outer Border

                    // Card Grid
                    GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        containerWidth * (125 / 917),
                        containerHeight * (56 / 412),
                        containerWidth * (125 / 917),
                        containerHeight * (56 / 412),
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
                    Positioned(
                      top: 15,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Settings()),
                          );
                        },
                        child: Image.asset(
                          'assets/assetsMainPage/settings_icon.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
