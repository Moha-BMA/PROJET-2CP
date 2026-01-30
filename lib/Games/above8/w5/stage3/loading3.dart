import 'package:flutter/material.dart';
import 'package:chainage1/Games/above8/w5/stage3/QuizP1/QuizP.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class LoadingScreen3 extends StatefulWidget {
  final Widget nextScreen=QuizP();
  final Duration duration;
  final Color barColor;

   LoadingScreen3({
    Key? key,
    this.duration = const Duration(seconds: 2),
     this.barColor=Colors.green,
  }) : super(key: key);

  @override
  State<LoadingScreen3> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen3> {
  double _loadingPercent = 0.0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    const int tickMs = 50;
    final int totalTicks = widget.duration.inMilliseconds ~/ tickMs;
    int ticks = 0;

    _timer = Timer.periodic(
      const Duration(milliseconds: tickMs),
          (timer) {
        ticks++;
        setState(() {
          _loadingPercent = (ticks / totalTicks).clamp(0.0, 1.0);
        });

        if (ticks >= totalTicks) {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => VideoScreen()),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: h * 0.05,
            left: (w - w * 0.6) / 2,
            child: Column(
              children: [
                Text(
                  '. . . جاري التحميل',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: h * 0.01),
                Container(
                  width: w * 0.6,
                  height: h * 0.015,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _loadingPercent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.barColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlowClipper extends CustomClipper<Path> {
  final double progress;

  FlowClipper(this.progress);

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double width = size.width;
    final double height = size.height;

    if (progress <= 0.0) {
      return Path();
    } else if (progress >= 1.0) {
      path.addRect(Rect.fromLTWH(0, 0, width, height));
      return path;
    }

    final double waveWidth = width * 0.5;
    final double progressWidth = width * progress;
    final double startX = progressWidth - waveWidth / 2;

    path.moveTo(0, 0);
    path.lineTo(startX, 0);
    path.quadraticBezierTo(
        startX + waveWidth * 0.5, 0, startX + waveWidth * 0.5, height * 0.2);
    path.quadraticBezierTo(
        startX + waveWidth, height * 0.4, startX + waveWidth, height * 0.5);
    path.quadraticBezierTo(
        startX + waveWidth, height * 0.6, startX + waveWidth * 0.5, height * 0.8);
    path.quadraticBezierTo(startX, height, startX, height);
    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

// VIDEO SCREEN
class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _showSkip = false;
  double _skipOpacity = 0.0;
  Timer? _hideTimer;
  Timer? _videoEndTimer;
  bool _isTransitioning = false;
  late AnimationController _transitionController;
  late Animation<double> _transitionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/wilayas/w5/stage3.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setVolume(1.0);
        _controller.play();

        _videoEndTimer = Timer(
          _controller.value.duration,
              () => startFlowTransition(),
        );
      });

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _transitionAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    );

    _transitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => QuizP(),
            transitionDuration: Duration.zero,
          ),
        );
      }
    });
  }

  void startFlowTransition() {
    if (_isTransitioning) return;

    setState(() {
      _isTransitioning = true;
    });

    _transitionController.forward(from: 0.0);
  }

  void _handleTapAnywhere() {
    setState(() {
      _showSkip = true;
      _skipOpacity = 1.0;
    });

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _skipOpacity = 0.0;
        });

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            setState(() {
              _showSkip = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    _videoEndTimer?.cancel();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF258932),
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? Container(
              width: 736,
              height: 414,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF3E1F0E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD700), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
                : const Center(child: CircularProgressIndicator()),
          ),

          // Transparent gesture detector on top of everything
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleTapAnywhere,
              child: Container(), // transparent layer
            ),
          ),

          if (_showSkip)
            Positioned(
              right: w * 0.01,
              top: h * 0.8,
              child: AnimatedOpacity(
                opacity: _skipOpacity,
                duration: const Duration(milliseconds: 400),
                child: GestureDetector(
                  onTap: () {
                    _videoEndTimer?.cancel();
                    startFlowTransition();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFC300)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Text(
                      'تخطي',
                      style: TextStyle(
                        fontFamily: 'AQEEQSANSPRO-ExtraBold',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF522C0B),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (_isTransitioning)
            AnimatedBuilder(
              animation: _transitionAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: FlowClipper(_transitionAnimation.value),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF258932), Color(0xFFFFD700)],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}