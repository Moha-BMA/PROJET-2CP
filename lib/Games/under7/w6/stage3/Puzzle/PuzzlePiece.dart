import 'package:flutter/material.dart';


class PuzzlePiece {
  final int id;
  final ImageProvider imageProvider;
  final Size imageSize;
  final Rect pieceRect;
  Offset initialPosition;  // Changed to non-final to allow reassignment
  Offset? currentPosition;
  final Size size;

  PuzzlePiece({
    required this.id,
    required this.imageProvider,
    required this.imageSize,
    required this.pieceRect,
    required this.initialPosition,
    this.currentPosition,
    required this.size,
  });

  Widget build() {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1),
      ),
      child: Image(
        image: imageProvider,
        fit: BoxFit.cover,
      ),
    );
  }
}