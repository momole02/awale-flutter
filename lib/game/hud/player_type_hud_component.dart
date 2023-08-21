import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum PlayerTypeHudOrientation {
  upward,
  downward,
}

/// Composant permettant d'afficher le type de joueur
/// Humain / AI
class PlayerTypeHudComponent extends CustomPainterComponent {
  double lineHeight;
  String text;
  PlayerTypeHudOrientation orientation;

  PlayerTypeHudComponent({
    required super.position,
    required this.lineHeight,
    required this.text,
    required this.orientation,
  });
  @override
  FutureOr<void> onLoad() {
    painter = PlayerTypeHudPainter(
        startX: position.x,
        startY: position.y,
        lineHeight: lineHeight,
        text: text,
        orientation: orientation);
  }
}

class PlayerTypeHudPainter extends CustomPainter {
  double startX;
  double startY;
  double lineHeight;
  String text;
  PlayerTypeHudOrientation orientation;

  PlayerTypeHudPainter({
    required this.startX,
    required this.startY,
    required this.lineHeight,
    required this.text,
    required this.orientation,
  });

  void _drawUpward(Canvas canvas, Size size) {
    // La ligne entre l'origine et le cadre du texte
    canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, startY - lineHeight),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white);

    final textPaint = TextPaint(
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
    final textPainter = textPaint.toTextPainter(text);
    // le texte
    textPainter.paint(
      canvas,
      Offset(startX - textPainter.width / 2,
          startY - lineHeight - textPainter.height),
    );
    // le cadre du texte
    canvas.drawRect(
        Rect.fromPoints(
            Offset(startX - textPainter.width / 2,
                startY - lineHeight - textPainter.height),
            Offset(startX + textPainter.width / 2, startY - lineHeight)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white);
  }

  void _drawDownward(Canvas canvas, Size size) {
    // La ligne entre l'origine et le cadre du texte
    canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, startY + lineHeight),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white);

    final textPaint = TextPaint(
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
    final textPainter = textPaint.toTextPainter(text);
    // le texte
    textPainter.paint(
      canvas,
      Offset(startX - textPainter.width / 2, startY + lineHeight),
    );

    // le cadre du texte
    canvas.drawRect(
        Rect.fromPoints(
            Offset(startX - textPainter.width / 2, startY + lineHeight),
            Offset(startX + textPainter.width / 2,
                startY + lineHeight + textPainter.height)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white);
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (orientation) {
      case PlayerTypeHudOrientation.upward:
        _drawUpward(canvas, size);
        break;
      case PlayerTypeHudOrientation.downward:
        _drawDownward(canvas, size);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
