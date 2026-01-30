import 'package:flutter/material.dart';
import 'package:chainage1/Games/above8/w5/stage1/Puzzle/JigsawPuzzleScreen.dart';
import 'dart:math';
import 'dart:async'; // Import for timer functionality
import 'package:chainage1/Games/above8/w5/stage1/Settings.dart';
class QuizP extends StatefulWidget {
  // Add parameter to receive accumulated time from previous questions
  final int previousTimeInSeconds;

  // Constructor with optional parameter
  const QuizP({super.key, this.previousTimeInSeconds = 0});

  @override
  _QuizPState createState() => _QuizPState();
}

class _QuizPState extends State<QuizP> with SingleTickerProviderStateMixin {
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

  // Timer related variables
  final Stopwatch _stopwatch = Stopwatch(); // To track elapsed time
  Timer? _timer; // Timer for updating UI
  String _timeDisplay = "00:00"; // Formatted time display
  int _elapsedTimeInSeconds = 0; // Elapsed time in seconds
  int _totalTimeInSeconds = 0; // Total time including previous questions

  // Question info
  final String _question = "ما أعلى قمة جبلية في وهران؟";
  final String _correctAnswer = "جبل مرجاجو";
  final List<String> _incorrectAnswers = [
    "جبل تاهات",
    "جبل شريعة",
    "جبل شيليا",
  ];

  // Hint text
  final String _hintText = "هذا المعلم يقع على تل مرتفع ويطل على البحر";

  // City name
  final String _cityName = "الولاية 5";

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize total time with previous accumulated time
    _totalTimeInSeconds = widget.previousTimeInSeconds;

    // Randomize the correct answer position
    _randomizeCorrectPosition();

    // Start the timer immediately when the quiz loads
    _startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _stopTimer();
    super.dispose();
  }

  // Method to start the timer
  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        // Update elapsed time for this question
        _elapsedTimeInSeconds = _stopwatch.elapsedMilliseconds ~/ 1000;

        // Calculate total time (previous questions + current question)
        _totalTimeInSeconds =
            widget.previousTimeInSeconds + _elapsedTimeInSeconds;

        // Update time display for current question
        int minutes = _elapsedTimeInSeconds ~/ 60;
        int seconds = _elapsedTimeInSeconds % 60;
        _timeDisplay =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      });
    });
  }

  // Method to stop the timer
  void _stopTimer() {
    _timer?.cancel();
    _stopwatch.stop();
  }

  // Method to format total time for display
  String _formatTotalTime() {
    int minutes = _totalTimeInSeconds ~/ 60;
    int seconds = _totalTimeInSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // Method to randomize the position of the correct answer
  void _randomizeCorrectPosition() {
    setState(() {
      _correctPosition = Random().nextInt(4) + 1; // 1-4
    });
  }

  // Method to handle answer selection
  void _handleAnswerSelected(int boxPosition) {
    if (_hasWon || _showSettings || _showHint)
      return; // Prevent selection when popups are shown

    setState(() {
      _selectedBox = boxPosition;
    });

    bool isCorrect = boxPosition == _correctPosition;

    // Play animation
    _animationController.forward().then((_) {
      if (isCorrect) {
        // If correct, stop the timer and show win message
        _stopTimer();
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
      return isCorrect
          ? Colors.green.withOpacity(_animationController.value)
          : Colors.red.withOpacity(_animationController.value);
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
          final String imagepath =
              'assets/assetsgamesunderabove/above8/wilaya5/stage1/quizp/quiz2.png';

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Image.asset(
                'assets/assetsQuiz/assetsQuizP/icons/quizphoto.png',
                fit: BoxFit.fill,
              ),

              Positioned(
                top: screenHeight * 0.139,
                left: screenWidth * 0.3414,
                right: screenWidth * 0.3414,
                bottom: screenHeight * 0.443,
                child: Image.asset(imagepath, fit: BoxFit.fill),
              ),

              // Timer Display (Current Question)
             /* Positioned(
                top: screenHeight * 0.3,
                right: screenWidth * 0.2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, color: Colors.white, size: 22),
                      SizedBox(width: 5),
                      Text(
                        _timeDisplay,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'AQEEQSANSPRO-ExtraBold',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Total Timer Display (If we have previous time)
              if (widget.previousTimeInSeconds > 0)
                Positioned(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.05,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_filled,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "الوقت الكلي: ${_formatTotalTime()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'AQEEQSANSPRO-ExtraBold',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/

              // Middle row boxes with text
              Positioned(
                top: screenHeight * 0.785,
                left: screenWidth * 0.03,
                right: screenWidth * 0.03,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleAnswerSelected(1), // Upper left
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              height: screenHeight * 0.13,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: _getBoxColor(1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
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
                              height: screenHeight * 0.13,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: _getBoxColor(3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _handleAnswerSelected(2), // Lower left
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Container(
                              height: screenHeight * 0.13,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: _getBoxColor(2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
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
                              height: screenHeight * 0.13,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: _getBoxColor(4),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
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
                top: screenHeight * 0.09,
                left: screenWidth * 0.075,
                child: Text(
                  _cityName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),

              // Round Text
              Positioned(
                top: screenHeight * 0.188,
                left: screenWidth * 0.104,
                child: Text(
                  "الجولة 1",
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
                top: screenHeight * 0.61,
                left: screenWidth * 0.2507,
                right: screenWidth * 0.28,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
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
                        // Responsive size using MediaQuery
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
                            Text(
                              'الوقت المستغرق: $_timeDisplay',
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
                                      builder:
                                          (context) => JigsawPuzzleScreen(
                                        // Pass the total time accumulated so far
                                        previousTimeInSeconds:
                                        _totalTimeInSeconds,
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

              // Settings popup - only appears when settings button is clicked
              /*if (_showSettings)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _toggleSettings, // Close when tapping outside
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {}, // Prevent closing when tapping on the image
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/assetsQuiz/assetsQuizP/icons/settings.png',
                                  width: 150,
                                  height: 150,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "الإعدادات",
                                  style: TextStyle(
                                    fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _toggleSettings,
                                  child: Text(
                                    "إغلاق",
                                    style: TextStyle(
                                      fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                      fontSize: 18,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),*/
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

              // Hint popup - only appears when hint button is clicked

            ],
          );
        },
      ),
    );
  }
}
