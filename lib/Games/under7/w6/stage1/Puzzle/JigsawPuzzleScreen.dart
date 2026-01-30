import 'dart:math';
import 'package:chainage1/Games/under7/w6/stage1/Settings.dart';
import 'package:chainage1/Wilayas_stages/under 7/w6/stage_screen6.dart';
import 'package:flutter/material.dart';
import 'package:chainage1/Games/under7/w6/stage1/loading1.dart';

import 'dart:async';
import 'GridPainter.dart';
import 'PuzzlePiece.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JigsawPuzzleScreen extends ConsumerStatefulWidget {
  // Add parameter to receive accumulated time from previous questions
  final int previousTimeInSeconds;

  // Constructor with optional parameter
  const JigsawPuzzleScreen({Key? key, this.previousTimeInSeconds = 0}) : super(key: key);

  @override
  ConsumerState<JigsawPuzzleScreen> createState() => _JigsawPuzzleScreenState();
}

class _JigsawPuzzleScreenState extends ConsumerState<JigsawPuzzleScreen> {
  final String puzzleImage = 'assets/assetsgamesunderabove/under7/wilaya6/stage1/puzzle/puzzle_image.jpg';
  List<PuzzlePiece> pieces = [];
  List<bool> correctlyPlaced = [];
  bool gameCompleted = false;
  int rows = 3;
  int columns = 3;
  Size puzzleAreaSize = Size(100, 100);
  double pieceWidth = 30;
  double pieceHeight = 30;
  final Random random = Random();

  // Stars for game completion
  bool firstStarEarned = false;   // Earned if completed puzzle
  bool secondStarEarned = false;  // Earned based on time (example)
  bool thirdStarEarned = false;   // Earned based on another condition
  int totalStarsEarned = 0;       // Total stars earned for this puzzle

  // Timer logic for current puzzle
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  String formattedTime = "00:00";

  // Total time tracking (previous questions + current puzzle)
  int _elapsedTimeInSeconds = 0;
  int _totalTimeInSeconds = 0;
  String _totalTimeDisplay = "00:00";
  Offset puzzleGridPosition = Offset.zero;
  @override
  void initState() {
    super.initState();
    // Initialize total time with previous accumulated time
    _totalTimeInSeconds = widget.previousTimeInSeconds;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePuzzle();
    });
  }

  void initializePuzzle() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double puzzleWidth = screenWidth * 0.3;
    double puzzleHeight = puzzleWidth;

    setState(() {
      puzzleAreaSize = Size(puzzleWidth, puzzleHeight);
      pieceWidth = puzzleWidth / columns;
      pieceHeight = puzzleHeight / rows;
      pieces = [];
      correctlyPlaced = List.generate(rows * columns, (_) => false);
      gameCompleted = false; // Reset game completion status
    });

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        int index = row * columns + col;
        Rect pieceRect = Rect.fromLTWH(col * pieceWidth, row * pieceHeight, pieceWidth, pieceHeight);
        PuzzlePiece piece = PuzzlePiece(
          id: index,
          imageProvider: AssetImage('assets/assetsgamesunderabove/under7/wilaya6/stage1/puzzle/puzzle_piece_${index + 1}.jpg'),
          imageSize: Size(pieceWidth, pieceHeight),
          pieceRect: pieceRect,
          initialPosition: Offset(0, 0),
          currentPosition: null,
          size: Size(pieceWidth, pieceHeight),
        );
        pieces.add(piece);
      }
    }

    List<Offset> availablePositions = generateInitialPositions();
    availablePositions.shuffle(random);
    for (int i = 0; i < pieces.length; i++) {
      pieces[i].initialPosition = availablePositions[i];
    }

    // Reset and start timer for this puzzle
    stopwatch.reset();
    stopwatch.start();
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        // Update time display for current puzzle
        formattedTime = _formatDuration(stopwatch.elapsed);

        // Update elapsed time for this puzzle
        _elapsedTimeInSeconds = stopwatch.elapsed.inSeconds;

        // Calculate and update total time (previous questions + current puzzle)
        _totalTimeInSeconds = widget.previousTimeInSeconds + _elapsedTimeInSeconds;
        _totalTimeDisplay = _formatTime(_totalTimeInSeconds);
      });
    });

    setState(() {});
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  // Helper method to format time in seconds to MM:SS format
  String _formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  List<Offset> generateInitialPositions() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    List<Offset> positions = [];
    double startX = screenWidth * 0.05;
    double startY = screenHeight * 0.2;
    double spacing = pieceWidth * 1.05;

    for (int i = 0; i < rows * columns; i++) {
      int row = i ~/ columns;
      int col = i % columns;
      positions.add(Offset(startX + col * spacing, startY + row * spacing));
    }
    return positions;
  }

  Offset calculateGridPosition(int row, int col) {
    double startX = MediaQuery.of(context).size.width * 0.5;
    double startY = MediaQuery.of(context).size.height * 0.3;
    return Offset(startX + col * pieceWidth, startY + row * pieceHeight);
  }

  bool isPieceInCorrectCell(int pieceId, Offset position) {
    int row = pieceId ~/ columns;
    int col = pieceId % columns;
    Offset correctPos = calculateGridPosition(row, col);
    double distance = (position - correctPos).distance;
    return distance < 20;
  }

  void checkGameCompletion() {
    print("Checking game completion: ${correctlyPlaced.toString()}");
    if (correctlyPlaced.every((placed) => placed)) {
      print("Game completed!");

      // Calculate stars earned based on total time (previous + current)
      // First star: always earned for completing the puzzle
      firstStarEarned = true;

      // Get total time in seconds
      int totalTimeInSeconds = _totalTimeInSeconds;  // Using the total time variable
      print("Total time for star calculation: $totalTimeInSeconds seconds");

      // Second star: earned if completed within total time threshold (e.g., 4 minutes)
      secondStarEarned = totalTimeInSeconds <= 60;  // 4 minutes

      // Third star: earned based on a faster time threshold (e.g., 2 minutes)
      thirdStarEarned = totalTimeInSeconds <= 50;  // 2 minutes

      // Calculate total stars earned
      totalStarsEarned = (firstStarEarned ? 1 : 0) +
          (secondStarEarned ? 1 : 0) +
          (thirdStarEarned ? 1 : 0);

      // Save stars to SharedPreferences
      saveStageCompletion();

      setState(() {
        gameCompleted = true;
        stopwatch.stop();
        timer?.cancel();
      });
    }
  }
  void saveStageCompletion() async {
    try {
      // Using SharedPreferences through Riverpod to save the stars earned for Wilaya 1, Stage 1
      final prefs = ref.read(sharedPreferencesProvider);

      // Get previously earned stars, if any
      int previousStars = prefs.getInt('W6_stage1_stars') ?? 0;

      // Only update if the player earned more stars than before
      if (totalStarsEarned > previousStars) {
        // Save stars earned for Wilaya 1, Stage 1
        await prefs.setInt('W6_stage1_stars', totalStarsEarned);

        // Mark stage as completed
        await prefs.setBool('W6_stage1_completed', true);

        // Update total wilaya progress if needed
        int currentProgress = prefs.getInt('S_wilaya6') ?? 1;
        if (currentProgress < 2 && totalStarsEarned > 0) {
          await prefs.setInt('S_wilaya6', 2); // Unlock stage 2
        }

        // Add stars to the global star count (only the difference)
        final starsNotifier = ref.read(starsProvider.notifier);
        starsNotifier.addStars(totalStarsEarned - previousStars);

        print("Stage completion saved: Wilaya 6, Stage 1 - $totalStarsEarned stars");
      } else {
        // Player didn't earn more stars than before, but the stage is still completed
        await prefs.setBool('W6_stage1_completed', true);
      }
    } catch (e) {
      print("Error saving stage completion: $e");
    }
  }

  void goToMenu() {
    // Navigate back to stage screen
    Navigator.pop(context);
  }

  void startNextGame() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => StageScreen6()),
          (route) => false, // This removes all previous routes from the stack
    );
  }

  void _showSettings() {
    // Implementation for showing settings
    print("Settings opened");
    // Add your settings logic here
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double puzzleTop = (MediaQuery.of(context).size.height - puzzleAreaSize.height) / 2 - 30;
    double puzzleLeft = MediaQuery.of(context).size.width * 0.6;

    // Store the position of the puzzle grid for correct piece placement
    puzzleGridPosition = Offset(puzzleLeft * 0.8, puzzleTop);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/assetsgames/assetsPuzzle/puzzle_bg_kids.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Settings Button
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

                // Puzzle grid area
                if (pieces.isNotEmpty)
                  Positioned(
                    top: puzzleTop,
                    left: puzzleLeft * 0.8,
                    child: Container(
                      width: puzzleAreaSize.width,
                      height: puzzleAreaSize.height,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.grey[200]?.withOpacity(0.4),
                      ),
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 1.0,
                            child: Image(
                              image: AssetImage(puzzleImage),
                              width: puzzleAreaSize.width,
                              height: puzzleAreaSize.height,
                              fit: BoxFit.cover,
                            ),
                          ),
                          CustomPaint(
                            size: puzzleAreaSize,
                            painter: GridPainter(rows: rows, columns: columns),
                          ),
                          // Draw empty cells for pieces that haven't been placed yet
                          ...List.generate(rows * columns, (index) {
                            int row = index ~/ columns;
                            int col = index % columns;
                            if (correctlyPlaced[index]) return SizedBox();
                            return Positioned(
                              left: col * pieceWidth,
                              top: row * pieceHeight,
                              child: Container(
                                width: pieceWidth,
                                height: pieceHeight,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            );
                          }),
                          // Drag targets for each puzzle piece position
                          ...List.generate(rows * columns, (index) {
                            int row = index ~/ columns;
                            int col = index % columns;
                            return Positioned(
                              left: col * pieceWidth,
                              top: row * pieceHeight,
                              child: DragTarget<int>(
                                builder: (context, candidateData, rejectedData) {
                                  return Container(
                                      width: pieceWidth,
                                      height: pieceHeight,
                                      color: Colors.transparent
                                  );
                                },
                                onAccept: (pieceId) {
                                  setState(() {
                                    if (pieceId == index) {
                                      pieces[pieceId].currentPosition = Offset(col * pieceWidth, row * pieceHeight);
                                      correctlyPlaced[pieceId] = true;
                                      checkGameCompletion();
                                    } else {
                                      pieces[pieceId].currentPosition = null;
                                    }
                                  });
                                },
                              ),
                            );
                          }),
                          // Draw correctly placed pieces directly in the grid
                          ...pieces.asMap().entries.map((entry) {
                            int index = entry.key;
                            PuzzlePiece piece = entry.value;
                            if (!correctlyPlaced[index]) return SizedBox();
                            int row = index ~/ columns;
                            int col = index % columns;
                            return Positioned(
                              left: col * pieceWidth,
                              top: row * pieceHeight,
                              child: piece.build(),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),

                // Draggable pieces that haven't been placed correctly yet
                if (pieces.isNotEmpty && !gameCompleted)
                  ...pieces.asMap().entries.map((entry) {
                    int index = entry.key;
                    PuzzlePiece piece = entry.value;
                    if (correctlyPlaced[index]) return SizedBox();
                    return Positioned(
                      left: piece.currentPosition?.dx ?? piece.initialPosition.dx,
                      top: piece.currentPosition?.dy ?? piece.initialPosition.dy,
                      child: Draggable<int>(
                        data: index,
                        feedback: piece.build(),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: piece.build(),
                        ),
                        onDragEnd: (details) {
                          if (!correctlyPlaced[index]) {
                            setState(() => piece.currentPosition = null);
                          }
                        },
                        child: piece.build(),
                      ),
                    );
                  }).toList(),

                // Game completion screen
                if (gameCompleted)
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Base award image
                          Transform.translate(
                            offset: Offset(-12, 0),
                            child: Image.asset(
                              'assets/assetsgames/assetsPuzzle/award_template.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Content container for positioning reference
                          Positioned(
                            top: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.02,
                            left: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.03,
                            child: Stack(
                              children: [
                                // First star
                                Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * -0.19,
                                    MediaQuery.of(context).size.height * 0.07,
                                  ),
                                  child: Image.asset(
                                    firstStarEarned ? 'assets/assetsgames/assetsPuzzle/star_yellow.png' : 'assets/assetsgames/assetsPuzzle/star_gray.png',
                                    width: MediaQuery.of(context).size.width * 0.085,
                                    height: MediaQuery.of(context).size.width * 0.085,
                                  ),
                                ),

                                // Second star
                                Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * -0.11,
                                    MediaQuery.of(context).size.height * 0.037,
                                  ),
                                  child: Image.asset(
                                    secondStarEarned ? 'assets/assetsgames/assetsPuzzle/star_yellow.png' : 'assets/assetsgames/assetsPuzzle/star_gray.png',
                                    width: MediaQuery.of(context).size.width * 0.1,
                                    height: MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ),

                                // Third star
                                Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * -0.05,
                                    MediaQuery.of(context).size.height * 0.07,
                                  ),
                                  child: Image.asset(
                                    thirdStarEarned ? 'assets/assetsgames/assetsPuzzle/star_yellow.png' : 'assets/assetsgames/assetsPuzzle/star_gray.png',
                                    width: MediaQuery.of(context).size.width * 0.085,
                                    height: MediaQuery.of(context).size.width * 0.085,
                                  ),
                                ),

                                // Display total stars earned
                                Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * -0.055,
                                    MediaQuery.of(context).size.height * 0.25,
                                  ),
                                  child: Text(
                                    'النجوم المكتسبة: $totalStarsEarned',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                    ),
                                  ),
                                ),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                                // Total time display
                                Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * -0.055,
                                    MediaQuery.of(context).size.height * 0.3,
                                  ),
                                  child: Text(
                                    'الوقت الإجمالي: $_totalTimeDisplay',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'AQEEQSANSPRO-ExtraBold',
                                    ),
                                  ),
                                ),

                                // Next Game Button
                                Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * -0.046,
                                    MediaQuery.of(context).size.height * 0.39,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      startNextGame();
                                    },
                                    child: Image.asset(
                                      'assets/assetsgames/assetsPuzzle/next_game_button.png',
                                      width: MediaQuery.of(context).size.width * 0.06,
                                      height: MediaQuery.of(context).size.width * 0.06,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),

                                // Play Again Button
                                Transform.translate(
                                  offset: Offset(
                                    MediaQuery.of(context).size.width * -0.203,
                                    MediaQuery.of(context).size.height * 0.38,
                                  ),
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
                                      width: MediaQuery.of(context).size.width * 0.067,
                                      height: MediaQuery.of(context).size.width * 0.067,
                                      fit: BoxFit.contain,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}