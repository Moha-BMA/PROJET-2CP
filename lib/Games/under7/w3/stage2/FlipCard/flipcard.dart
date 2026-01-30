import 'package:flutter/material.dart';
import 'dart:math';
import 'package:chainage1/card+gameplay/Card_Screen.dart';

// A class to represent card data
class CardData {
  final String frontImage;
  final String backImage;
  final int pairId;

  CardData({required this.frontImage, required this.backImage, required this.pairId});
}

class FlipContainer extends StatefulWidget {
  final CardData cardData;
  final Function(int) onCardFlipped;
  final bool canFlip;
  final bool shouldDisappear;
  final bool shouldFlipBack;
  final VoidCallback onFlipBackComplete;
  final VoidCallback onDisappearComplete;

  const FlipContainer({
    super.key,
    required this.cardData,
    required this.onCardFlipped,
    required this.canFlip,
    this.shouldDisappear = false,
    this.shouldFlipBack = false,
    required this.onFlipBackComplete,
    required this.onDisappearComplete,
  });

  @override
  _FlipContainerState createState() => _FlipContainerState();
}

class _FlipContainerState extends State<FlipContainer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;
  bool _isVisible = true;
  bool _processingDisappear = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);

    // Listen for animation status changes
    _controller.addStatusListener((status) {
      // Handle flip back completion
      if (status == AnimationStatus.dismissed && widget.shouldFlipBack) {
        widget.onFlipBackComplete();
      }

      // Handle disappear after flip is complete
      if (status == AnimationStatus.completed && widget.shouldDisappear && !_processingDisappear) {
        _processingDisappear = true;
        // Wait a moment before disappearing
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _isVisible = false;
            });
            widget.onDisappearComplete();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(FlipContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle flip back command
    if (widget.shouldFlipBack && !oldWidget.shouldFlipBack && _isFlipped) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _controller.reverse();
          setState(() {
            _isFlipped = false;
          });
        }
      });
    }

    // Handle new disappear command
    if (widget.shouldDisappear && !oldWidget.shouldDisappear && _isVisible && !_processingDisappear) {
      // If the card is already flipped, start the disappear process
      if (_isFlipped) {
        _processingDisappear = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _isVisible = false;
            });
            widget.onDisappearComplete();
          }
        });
      }
      // If not flipped yet, let the animation listener handle it
    }
  }

  void _flipCard() {
    if (!widget.canFlip || !_isVisible) return;

    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
      widget.onCardFlipped(widget.cardData.pairId);
    }

    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox(); // Return empty space when card should be invisible
    }

    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isBackVisible = _animation.value > pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_animation.value),
            child: isBackVisible
                ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi), // Correct the back orientation
              child: _buildBack(),
            )
                : _buildFront(),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    var screenSize = MediaQuery.of(context).size;
    double squareSize = screenSize.shortestSide * (128 / 412);

    return Container(
      width: squareSize,
      height: squareSize,
      child: Stack(
        children: [
          // Green and Yellow Border Containers
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF258932), // Outer Green
              border: Border.all(
                width: squareSize * (5.82 / 128),
                color: const Color(0xFF258932),
              ),
            ),
            padding: const EdgeInsets.all(1), // Space for the yellow border
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFC717), // Middle Yellow
                border: Border.all(
                  width: squareSize * (3 / 128),
                  color: const Color(0xFFEFC717),
                ),
              ),
              padding: const EdgeInsets.all(1), // Space for the inner green box
              child: Container(
                width: squareSize,
                height: squareSize,
                decoration: const BoxDecoration(
                  color: Color(0xFF258932), // Inner Green
                ),
                child: Image.asset(
                  widget.cardData.frontImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Add dizzy effect (Placed on top)
          Positioned(
            top: squareSize*0.01,
            right: squareSize*0.01,
            width: squareSize * 0.3,
            height: squareSize * 0.3,
            child: Image.asset(
              'assets/assetsgames/assetsFlipCard/icons/Dizzy.png',
              fit: BoxFit.contain,
            ),
          ),

          // Add sparkles effect (Placed on top)
          Positioned(
            bottom: squareSize*0.07,
            left: squareSize * 0.09,
            width: squareSize * 0.30,
            height: squareSize * 0.30,
            child: Image.asset(
              'assets/assetsgames/assetsFlipCard/icons/Sparkles.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack() {
    var screenSize = MediaQuery.of(context).size;
    double squareSize = screenSize.shortestSide * (128 / 412);

    return Container(
      width: squareSize,
      height: squareSize,
      child: Center(
        child: Image.asset(
          widget.cardData.backImage,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}