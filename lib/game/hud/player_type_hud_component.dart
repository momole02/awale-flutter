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
        lineHeight: lineHeight, text: text, orientation: orientation);
  }
}

class PlayerTypeHudPainter extends CustomPainter {
  double lineHeight;
  String text;
  PlayerTypeHudOrientation orientation;

  PlayerTypeHudPainter({
    required this.lineHeight,
    required this.text,
    required this.orientation,
  });

  void _drawUpward(Canvas canvas, Size size) {
    // La ligne entre l'origine et le cadre du texte
    canvas.drawLine(
        const Offset(0, 0),
        Offset(0, -lineHeight),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.grey.shade300);

    final textPaint = TextPaint(
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
    final textPainter = textPaint.toTextPainter(text);
    // le texte
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -lineHeight - textPainter.height),
    );
    // le cadre du texte
    canvas.drawRect(
        Rect.fromPoints(
            Offset(-textPainter.width / 2, -lineHeight - textPainter.height),
            Offset(textPainter.width / 2, -lineHeight)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.grey.shade300);
  }

  void _drawDownward(Canvas canvas, Size size) {
    // La ligne entre l'origine et le cadre du texte
    canvas.drawLine(
        const Offset(0, 0),
        Offset(0, lineHeight),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.grey.shade300);

    final textPaint = TextPaint(
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
    final textPainter = textPaint.toTextPainter(text);
    // le texte
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, lineHeight),
    );

    // le cadre du texte
    canvas.drawRect(
        Rect.fromPoints(Offset(-textPainter.width / 2, lineHeight),
            Offset(textPainter.width / 2, lineHeight + textPainter.height)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.grey.shade300);
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
