import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:awale_flutter/game/circles/circles_model.dart';
import 'package:awale_flutter/game/sprites/background_spr.dart';
import 'package:awale_flutter/game/sprites/bean_spr.dart';
import 'package:awale_flutter/game/sprites/paddle_spr.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int circlesPerPlayer = 7;
const double circleDeltaY = 10;

class AwaleGame extends FlameGame {
  List<Aabb2> p1Circles = [];
  List<Aabb2> p2Circles = [];
  double boardX = 0;
  double boardY = 0;
  List<BeanSprite> beans = [];

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    boardX = size.x / 10;
    boardY = size.y / 4;
    await _loadCircles();
    _setupScene();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // for (var circle in p1Circles) {
    //   canvas.drawRect(
    //     Rect.fromPoints(Offset(circle.min.x, circle.min.y),
    //         Offset(circle.max.x, circle.max.y)),
    //     Paint()
    //       ..style = PaintingStyle.stroke
    //       ..color = Colors.white,
    //   );
    // }

    // for (var circle in p2Circles) {
    //   canvas.drawRect(
    //     Rect.fromPoints(Offset(circle.min.x, circle.min.y),
    //         Offset(circle.max.x, circle.max.y)),
    //     Paint()
    //       ..style = PaintingStyle.stroke
    //       ..color = Colors.white,
    //   );
    // }
  }

  /// Charge les AABBs associées aux cercles
  _loadCircles() async {
    final jsonString = await rootBundle.loadString("assets/circles.json");
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    CirclesModel circlesModel = CirclesModel.fromJson(jsonData);
    _extractPlayer1Circles(circlesModel);
    _extractPlayer2Circles(circlesModel);
  }

  void _extractPlayer1Circles(CirclesModel circlesModel) {
    for (final [x, y, w, h] in circlesModel.player1) {
      p1Circles.add(
        Aabb2.minMax(
          Vector2(boardX + x, boardY + y - circleDeltaY),
          Vector2(boardX + x + w - 1.0, boardY + y + h - 1.0 - circleDeltaY),
        ),
      );
    }
  }

  void _extractPlayer2Circles(CirclesModel circlesModel) {
    for (final [x, y, w, h] in circlesModel.player2) {
      p2Circles.add(
        Aabb2.minMax(
          Vector2(boardX + x + 0.0, boardY + y + 0.0 - circleDeltaY),
          Vector2(boardX + x + w - 1.0, boardY + y + h - 1.0 - circleDeltaY),
        ),
      );
    }
  }

  void _setupScene() {
    addAll([
      BackgroundSprite(size: Vector2(size.x, size.y)),
      PaddleSprite(position: Vector2(boardX, boardX)),
    ]);
    _initBeansPosition();
  }

  void _initBeansPosition() {
    beans = List.generate(2 * 4 * circlesPerPlayer,
        (index) => BeanSprite(position: _beanPosition(index)));
    addAll(beans);
  }

  Vector2 _randomPositionInCircle(Aabb2 circle) {
    final rnd = Random();
    double xMax = (1 + circle.max.x - circle.min.x) - beanSize;
    double xMin = circle.min.x;
    double yMax = (1 + circle.max.y - circle.min.y) - beanSize;
    double yMin = circle.min.y;
    return Vector2(
      // circle.max.x - beanSize, circle.max.y - beanSize,
      rnd.nextDouble() * xMax + xMin,
      rnd.nextDouble() * yMax + yMin,
    );
  }

  Vector2 _beanPosition(int index) {
    //i dans [0,4[ => position(i) dans cp1(0)
    //i dans [4,8[ => position(i) dans cp1(1)
    //i dans [8,12[ => position(i) dans cp1(2)
    //...
    //i dans [4*circlesPerPlayer-4, 4*circlesPerPlayer[ => position(i) dans cp1(n-1)
    //..
    if (index < 4 * circlesPerPlayer) {
      int circle = (index / 4).floor();
      return _randomPositionInCircle(p1Circles[circle]);
    } else {
      int circle = ((index - 4 * circlesPerPlayer) / 4).floor();
      return _randomPositionInCircle(p2Circles[circle]);
    }
  }
}
