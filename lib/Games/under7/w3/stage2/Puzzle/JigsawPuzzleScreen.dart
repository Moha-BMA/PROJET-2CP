import 'dart:math';
import 'package:chainage1/Games/under7/w3/stage2/loading2.dart';
import 'package:chainage1/Wilayas_stages/under 7/w3/stage_screen3.dart';
import 'package:flutter/material.dart';
import 'package:chainage1/Games/under7/w3/stage2/Settings.dart';
import 'dart:async';
import 'GridPainter.dart';
import 'PuzzlePiece.dart';
import 'package:chainage1/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class JigsawPuzzleScreen extends ConsumerStatefulWidget {
  final int previousTimeInSeconds;

  const JigsawPuzzleScreen({Key? key, this.previousTimeInSeconds = 0}) : super(key: key);

  @override
  ConsumerState<JigsawPuzzleScreen> createState() => _JigsawPuzzleScreenState();
}

class _JigsawPuzzleScreenState extends ConsumerState<JigsawPuzzleScreen> with SingleTickerProviderStateMixin {
  final String puzzleImage = 'assets/assetsgamesunderabove/under7/wilaya3/stage2/puzzle/puzzle_image.png';
  List<PuzzlePiece> pieces = [];
  List<bool> correctlyPlaced = [];
  bool gameCompleted = false;
  int rows = 3;
  int columns = 3;
  Size puzzleAreaSize = Size(100, 100);
  double pieceWidth = 30;
  double pieceHeight = 30;
  final Random random = Random();
  bool firstStarEarned = false;
  bool secondStarEarned = false;
  bool thirdStarEarned = false;
  int totalStarsEarned = 0;
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  String formattedTime = "00:00";
  int _elapsedTimeInSeconds = 0;
  int _totalTimeInSeconds = 0;
  String _totalTimeDisplay = "00:00";
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isTrophyContainerVisible = false;
  bool _isFirstNextPress = false;
  bool _showGameCompletion = false; // Added to control award template visibility
  Offset puzzleGridPosition = Offset.zero;
  @override
  void initState() {
    super.initState();
    _totalTimeInSeconds = widget.previousTimeInSeconds;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePuzzle();
      final prefs = ref.read(sharedPreferencesProvider);
      _isFirstNextPress = !(prefs.getBool('W3_stage2_next_pressed') ?? false);
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      gameCompleted = false;
      _showGameCompletion = false;
    });

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        int index = row * columns + col;
        Rect pieceRect = Rect.fromLTWH(col * pieceWidth, row * pieceHeight, pieceWidth, pieceHeight);
        PuzzlePiece piece = PuzzlePiece(
          id: index,
          imageProvider: AssetImage('assets/assetsgamesunderabove/under7/wilaya3/stage2/puzzle/puzzle_piece_${index + 1}.png'),
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

    stopwatch.reset();
    stopwatch.start();
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        formattedTime = _formatDuration(stopwatch.elapsed);
        _elapsedTimeInSeconds = stopwatch.elapsed.inSeconds;
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
      firstStarEarned = true;
      secondStarEarned = _totalTimeInSeconds <= 60;
      thirdStarEarned = _totalTimeInSeconds <= 50;
      totalStarsEarned = (firstStarEarned ? 1 : 0) + (secondStarEarned ? 1 : 0) + (thirdStarEarned ? 1 : 0);
      saveStageCompletion();
      setState(() {
        gameCompleted = true;
        stopwatch.stop();
        timer?.cancel();
        if (_isFirstNextPress) {
          _isTrophyContainerVisible = true;
          _controller.forward(from: 0);
        } else {
          _showGameCompletion = true;
        }
      });
    }
  }

  void saveStageCompletion() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      int previousStars = prefs.getInt('W3_stage2_stars') ?? 0;
      if (totalStarsEarned > previousStars) {
        await prefs.setInt('W3_stage2_stars', totalStarsEarned);
        await prefs.setBool('W3_stage2_completed', true);
        int currentProgress = prefs.getInt('S_wilaya3') ?? 1;
        if (currentProgress < 2 && totalStarsEarned > 0) {
          await prefs.setInt('S_wilaya3', 2);
        }
        final starsNotifier = ref.read(starsProvider.notifier);
        starsNotifier.addStars(totalStarsEarned - previousStars);
        print("Stage completion saved: Wilaya 3, Stage 2 - $totalStarsEarned stars");
      } else {
        await prefs.setBool('W3_stage2_completed', true);
      }
    } catch (e) {
      print("Error saving stage completion: $e");
    }
  }

  void startNextGame() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => StageScreen3()),
          (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    double puzzleTop = (MediaQuery.of(context).size.height - puzzleAreaSize.height) / 2 - 30;
    double puzzleLeft = MediaQuery.of(context).size.width * 0.6;

    // Store the position of the puzzle grid for correct piece placement
    double gridPositionLeft = puzzleLeft * 0.8;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/assetsgames/assetsPuzzle/puzzle_bg_kids.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
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

                if (pieces.isNotEmpty)
                  Positioned(
                    top: puzzleTop,
                    left: gridPositionLeft, // Use consistent position
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
                              fit: BoxFit.fill,
                            ),
                          ),
                          CustomPaint(
                            size: puzzleAreaSize,
                            painter: GridPainter(rows: rows, columns: columns),
                          ),
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
                                    color: Colors.transparent,
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
                        ],
                      ),
                    ),
                  ),
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
                if (pieces.isNotEmpty)
                  Positioned(
                    top: puzzleTop,
                    left: gridPositionLeft, // Use the same position as the grid
                    child: Stack(
                      children: pieces.asMap().entries.map((entry) {
                        int index = entry.key;
                        PuzzlePiece piece = entry.value;
                        if (!correctlyPlaced[index]) return SizedBox();
                        int row = index ~/ columns;
                        int col = index % columns;
                        return Positioned(
                          left: col * pieceWidth,
                          top: row * pieceHeight,
                          child: Opacity(
                            opacity: 1.0,
                            child: piece.build(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (_showGameCompletion)
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

                                // Menu Button
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
                                        MaterialPageRoute(builder: (context) => LoadingScreen2()),
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

                if (_isTrophyContainerVisible)
                  GestureDetector(
                    onTap: () async {
                      final prefs = ref.read(sharedPreferencesProvider);
                      await prefs.setBool('W3_stage2_next_pressed', true);
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
                                      'assets/assetsTrophyspace/images/trophy3_col.png',
                                      width: MediaQuery.of(context).size.width*(200/917),
                                      height: MediaQuery.of(context).size.height*(300/412),
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
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