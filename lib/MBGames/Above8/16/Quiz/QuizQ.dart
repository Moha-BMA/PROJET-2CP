import 'package:chainage1/Mystery%20Boxes/Above8/Mystery%20Boxes.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:chainage1/MBGames/Above8/16/Settings.dart';
class QuizQ extends StatefulWidget {
  @override
  _QuizQState createState() => _QuizQState();
}

class _QuizQState extends State<QuizQ> with SingleTickerProviderStateMixin {
  // Animation controller for answer feedback animations
  late AnimationController _animationController;

  // Correct position (1-4) to place the correct answer
  int _correctPosition = 1;

  // Tracks which box was selected (1-4)
  int? _selectedBox;

  // Track if player has won
  bool _hasWon = false;

  // Track if settings dialog is open
  bool _showSettings = false;

  // Track if hint dialog is open
  bool _showHint = false;

  // Question info
  final String _question = "كم يبلغ طول الساحل الجزائري؟";
  final String _correctAnswer = " 1622كلم";
  final List<String> _incorrectAnswers = [
    " 500كلم",
    " 1200كلم",
    " 2000كلم"

  ];

  // Hint text
  final String _hintText = "هذا المعلم يقع على تل مرتفع ويطل على البحر";

  // City name
  final String _cityName = "الصندوق العشوائي";

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Randomize the correct answer position
    _randomizeCorrectPosition();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to randomize the position of the correct answer
  void _randomizeCorrectPosition() {
    setState(() {
      _correctPosition = Random().nextInt(4) + 1; // 1-4
    });
  }

  // Method to handle answer selection
  void _handleAnswerSelected(int boxPosition) {
    if (_hasWon || _showSettings || _showHint) return; // Prevent selection when popups are shown

    setState(() {
      _selectedBox = boxPosition;
    });

    bool isCorrect = boxPosition == _correctPosition;

    // Play animation
    _animationController.forward().then((_) {
      if (isCorrect) {
        // If correct, show win message
        setState(() {
          _hasWon = true;
        });
      } else {
        // If incorrect, reset animation and let them try again
        _animationController.reset();
        setState(() {
          _selectedBox = null;
        });
      }
    });
  }

  // Toggle settings dialog
  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
      // Close hint if open
      if (_showSettings) {
        _showHint = false;
      }
    });
  }

  // Toggle hint dialog
  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
      // Close settings if open
      if (_showHint) {
        _showSettings = false;
      }
    });
  }

  // Get all answers arranged according to the correct position
  List<String> _getArrangedAnswers() {
    List<String> answers = List.from(_incorrectAnswers);

    // Insert correct answer at the determined position (0-based index)
    switch (_correctPosition) {
      case 1: // Upper left
        answers.insert(0, _correctAnswer);
        break;
      case 2: // Lower left
        answers.insert(2, _correctAnswer);
        break;
      case 3: // Upper right
        answers.insert(1, _correctAnswer);
        break;
      case 4: // Lower right
        answers.insert(3, _correctAnswer);
        break;
    }

    return answers.take(4).toList();
  }

  // Method to determine box color based on selection and correctness
  Color _getBoxColor(int boxPosition) {
    if (_selectedBox == boxPosition) {
      bool isCorrect = boxPosition == _correctPosition;
      return isCorrect ? Colors.green.withOpacity(_animationController.value) : Colors.red.withOpacity(_animationController.value);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> arrangedAnswers = _getArrangedAnswers();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final double startX = screenWidth * 0.02;
          final double startY = screenHeight * 0.02;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                'assets/assetsQuiz/assetsQuizQ/icons/QUIZ.png',
                fit: BoxFit.fill,
              ),
              Positioned(
                top: screenHeight * 0.6,
                left: screenWidth * 0.3,
                right: screenWidth * 0.34,
                bottom:screenHeight * 0.13 ,
                child: Image.asset(
                  'assets/assetsQuiz/assetsQuizQ/icons/head.png',
                ),
              ),
              // Middle row boxes with text
              Positioned(
                top: screenHeight * 0.594,
                left: 0,
                right: screenWidth * 0.05,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleAnswerSelected(1), // Upper left
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              height: screenHeight * 0.11,
                              margin: EdgeInsets.symmetric(horizontal: 79),
                              decoration: BoxDecoration(
                                color: _getBoxColor(1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  arrangedAnswers[0],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleAnswerSelected(3), // Upper right
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              height: screenHeight * 0.11,
                              margin: EdgeInsets.symmetric(horizontal: 79),
                              decoration: BoxDecoration(
                                color: _getBoxColor(3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  arrangedAnswers[1],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom row boxes with text
              Positioned(
                top: screenHeight * 0.764,
                left: 0,
                right: screenWidth * 0.05,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleAnswerSelected(2), // Lower left
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              height: screenHeight * 0.11,
                              margin: EdgeInsets.symmetric(horizontal: 79),
                              decoration: BoxDecoration(
                                color: _getBoxColor(2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  arrangedAnswers[2],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleAnswerSelected(4), // Lower right
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              height: screenHeight * 0.11,
                              margin: EdgeInsets.symmetric(horizontal: 79),
                              decoration: BoxDecoration(
                                color: _getBoxColor(4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  arrangedAnswers[3],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // City Name
              Positioned(
                top: screenHeight * 0.11,
                left: screenWidth * 0.05,
                child: Text(
                  _cityName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              // Round Text
              Positioned(
                top: screenHeight * 0.188,
                left: screenWidth * 0.104,
                child: Text(
                  "الجولة 16",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              // Question Container
              Positioned(
                top: screenHeight * 0.13,
                left: screenWidth * 0.355,
                right: screenWidth * 0.34,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(
                    child: Text(
                      _question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'AQEEQSANSPRO-ExtraBold',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),

              // Icons

              // "You won" message - only appears when won
              if (_hasWon)
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


              Positioned(
                top: 2 * startY,
                right: startX - screenWidth * 0.045,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  },
                  child: Image.asset(
                    'assets/assetsMainPage/settings_icon.png',
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.15,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}