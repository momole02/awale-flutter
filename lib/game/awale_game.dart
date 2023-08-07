import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:awale_flutter/game/circles/circles_model.dart';
import 'package:awale_flutter/game/gameplay/action_pattern.dart';
import 'package:awale_flutter/game/gameplay/actions/player_move_action.dart';
import 'package:awale_flutter/game/gameplay/actions/sprite_move_action.dart';
import 'package:awale_flutter/game/sprites/background_spr.dart';
import 'package:awale_flutter/game/sprites/bean_spr.dart';
import 'package:awale_flutter/game/sprites/paddle_spr.dart';
import 'package:flame/events.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const int circlesPerPlayer = 7;
const double circleDeltaY = 10;

class AwaleGame extends FlameGame with TapDetector {
  List<Aabb2> p1Circles = [];
  List<Aabb2> p2Circles = [];
  double boardX = 0;
  double boardY = 0;
  List<BeanSprite> beans = [];

  final ActionManager actionManager = ActionManager();

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    boardX = size.x / 10;
    boardY = size.y / 4;
    await _loadCircles();
    _setupScene();
    // actionManager.push(
    //   PlayerMoveAction(
    //       p1Circles: p1Circles,
    //       p2Circles: p2Circles,
    //       beans: beans,
    //       playCircle: p2Circles[0]),
    // );
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!actionManager.isRunning()) {
      List L = [...p1Circles, ...p2Circles];
      int index = L.indexWhere(
          (circle) => circle.containsVector2(info.eventPosition.global));
      if (-1 != index) {
        actionManager.push(
          PlayerMoveAction(
            p1Circles: p1Circles,
            p2Circles: p2Circles,
            beans: beans,
            playCircle: L[index],
            beanMoveDuration: 500,
          ),
        );
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    actionManager.performStuff();
  }

  /// Charge les AABBs associées aux cercles
  _loadCircles() async {
    final jsonString = await rootBundle.loadString("assets/circles.json");
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    CirclesModel circlesModel = CirclesModel.fromJson(jsonData);
    _extractPlayer1Circles(circlesModel);
    _extractPlayer2Circles(circlesModel);
  }

  /// Détermine la position des cercles du joueur 1
  /// (ceux du haut)
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

  /// Détermine la position des cercles du joueur 2
  /// (ceux du bas)
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

  /// Met en place la scène de jeu
  void _setupScene() {
    addAll([
      BackgroundSprite(size: Vector2(size.x, size.y)),
      PaddleSprite(position: Vector2(boardX, boardX)),
    ]);
    _initBeansPosition();
  }

  /// Initialise les positions des graines
  /// 4 par cercles
  void _initBeansPosition() {
    beans = List.generate(2 * 4 * circlesPerPlayer,
        (index) => BeanSprite(position: _beanPosition(index)));
    addAll(beans);
  }

  /// Calcul une position aléatoire au sein d'un cercle
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

  /// Détermine la position d'une graine au sein par
  /// rapport au cercles
  ///   i dans [0,4[ => position(i) dans cp1(0)
  ///   i dans [4,8[ => position(i) dans cp1(1)
  ///   i dans [8,12[ => position(i) dans cp1(2)
  ///   ...
  ///   i dans [4*circlesPerPlayer-4, 4*circlesPerPlayer[ => position(i) dans cp1(n-1)
  ///..
  Vector2 _beanPosition(int index) {
    if (index < 4 * circlesPerPlayer) {
      int circle = (index / 4).floor();
      return _randomPositionInCircle(p1Circles[circle]);
    } else {
      int circle = ((index - 4 * circlesPerPlayer) / 4).floor();
      return _randomPositionInCircle(p2Circles[circle]);
    }
  }
}
