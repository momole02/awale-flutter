import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:awale_flutter/game/circles/circles_model.dart';
import 'package:awale_flutter/game/gameplay/action_pattern.dart';
import 'package:awale_flutter/game/gameplay/actions/custom_callback_action.dart';
import 'package:awale_flutter/game/gameplay/actions/gain_move_action.dart';
import 'package:awale_flutter/game/gameplay/actions/gains_taking_action.dart';
import 'package:awale_flutter/game/gameplay/actions/player_move_action.dart';
import 'package:awale_flutter/game/gameplay/actions/sprite_move_action.dart';
import 'package:awale_flutter/game/gameplay/game_state_updater.dart';
import 'package:awale_flutter/game/sprites/background_spr.dart';
import 'package:awale_flutter/game/sprites/bean_spr.dart';
import 'package:awale_flutter/game/sprites/paddle_spr.dart';
import 'package:awale_flutter/game/sprites/stump_spr.dart';
import 'package:awale_flutter/simulator/state/game_state.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Nombre de cercles par joueur sur le plateau
const int circlesPerPlayer = 7;

/// Décalage Y utilisé pour le calcul des AABBs des
/// cercles sur le plateau
const double circleDeltaY = 0;

/// Decalage utilisé pour calculer les AABBs des
/// différentes souches des gains
const double stumpOffset = 20;

/// Définition des joueurs
///
enum Player {
  player1,
  player2,
}

class AwaleGame extends FlameGame with TapDetector {
  double boardX = 0;
  double boardY = 0;
  List<Aabb2> p1Circles = [];
  List<Aabb2> p2Circles = [];
  List<BeanSprite> beans = [];

  late StumpSprite p1Stump;
  late StumpSprite p2Stump;
  late TextComponent turnTextComponent;
  late Aabb2 p1aabb;
  late Aabb2 p2aabb;

  late Player currentPlayer;

  final ActionManager actionManager = ActionManager();

  GameState? state;

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    boardX = size.x / 10 + 10;
    boardY = size.y / 4;
    await _loadCircles();
    _setupScene();
    _updateGameState();
    _setPlayer1Turn();
  }

  /// Lorsque l'utilisateur tappe sur l'écran
  @override
  void onTapDown(TapDownInfo info) {
    // ... On s'assure qu'aucune autre action n'est en cours
    if (!actionManager.isRunning()) {
      if (currentPlayer == Player.player1) {
        _handlePlayer1Turn(info);
      } else {
        _handlePlayer2Turn(info);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    actionManager.performStuff();
  }

  @override
  render(Canvas canvas) {
    super.render(canvas);
    if (actionManager.isRunning()) {
      // aucun post traitement si une action est en cours
      return;
    }
    final beansCountTextPainter = TextPaint(
      style: TextStyle(
        fontSize: 30,
        color: Colors.white.withOpacity(0.7),
      ),
    );

    final gainsTextPainter = TextPaint(
        style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 45,
      color: Colors.black.withOpacity(0.7),
    ));

    // Afficher l'état du jeu (nombre de pions, etc...)
    for (int i = 0; i < p1Circles.length; ++i) {
      int count = state!.p1pad[i];
      beansCountTextPainter.render(canvas, "$count", p1Circles[i].min);
    }

    for (int i = 0; i < p1Circles.length; ++i) {
      int count = state!.p2pad[i];
      beansCountTextPainter.render(canvas, "$count", p2Circles[i].min);
    }

    int p1Gains = state!.p1points;
    int p2Gains = state!.p2points;
    gainsTextPainter.render(canvas, "$p1Gains", p1aabb.min);
    gainsTextPainter.render(canvas, "$p2Gains", p2aabb.min);
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
    p1Stump = StumpSprite(position: Vector2(0, 0));
    p2Stump = StumpSprite(
      position: Vector2(size.x - stumpSize, size.y - stumpSize - 10),
    );

    /// Calculer la AABB de la souche du joueur 1
    p1aabb = Aabb2.minMax(
      p1Stump.position + Vector2(stumpOffset, stumpOffset),
      p1Stump.position +
          Vector2(p1Stump.width - 1 - 2 * stumpOffset,
              p1Stump.height - 1 - 2 * stumpOffset),
    );

    /// Calculer la AABB de la souche du joueur 2
    p2aabb = Aabb2.minMax(
      p2Stump.position + Vector2(stumpOffset, stumpOffset),
      p2Stump.position +
          Vector2(p2Stump.width - 1 - 2 * stumpOffset,
              p2Stump.height - 1 - 2 * stumpOffset),
    );
    _initTurnText();
    addAll([
      BackgroundSprite(size: Vector2(size.x, size.y)),
      PaddleSprite(position: Vector2(boardX, boardY)),
      p1Stump,
      p2Stump,
      turnTextComponent,
    ]);
    _initBeansPosition();
  }

  void _initTurnText() {
    turnTextComponent = TextComponent(
      anchor: Anchor.topCenter,
      text: "A votre tour de jouer !",
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          backgroundColor: Color.fromARGB(255, 116, 91, 53),
        ),
      ),
    )
      ..x = size.x / 2
      ..y = 0;
  }

  /// Passe le tour au joueur joueur 1
  void _setPlayer1Turn() {
    currentPlayer = Player.player1;
    turnTextComponent.y = 0;
  }

  /// Passe le tour au joueur 2
  void _setPlayer2Turn() {
    currentPlayer = Player.player2;
    turnTextComponent.y = size.y - turnTextComponent.height - 1;
  }

  void _switchPlayerTurn() {
    if (currentPlayer == Player.player1) {
      _setPlayer2Turn();
    } else {
      _setPlayer1Turn();
    }
  }

  /// Attends le tour du joueur 1
  void _handlePlayer1Turn(TapDownInfo info) {
    int index = p1Circles.indexWhere(
        (circle) => circle.containsVector2(info.eventPosition.global));
    if (-1 != index) {
      _play(p1Circles[index]);
    }
  }

  /// Attends le tour du joueur 2
  void _handlePlayer2Turn(TapDownInfo info) {
    int index = p2Circles.indexWhere(
        (circle) => circle.containsVector2(info.eventPosition.global));
    if (-1 != index) {
      _play(p2Circles[index]);
    }
  }

  /// Effectue un jeu selon une case
  void _play(Aabb2 playCircle) {
    actionManager
        .push(
          // Effectue le jeu
          PlayerMoveAction(
            p1Circles: p1Circles,
            p2Circles: p2Circles,
            beans: beans,
            playCircle: playCircle,
          ),
        )
        .push(
          // Calcul l'état du jeu
          CustomCallbackAction(callback: (globals) => _updateGameState()),
        )
        .push(
          // Recupère les gains
          GainsTakingAction(
            gameState: state!,
            p1Circles: p1Circles,
            p2Circles: p2Circles,
            beans: beans,
            p1aabb: p1aabb,
            p2aabb: p2aabb,
          ),
        )
        .push(
          // Recalcul l'état du jeu
          CustomCallbackAction(callback: (globals) => _updateGameState()),
        )
        .push(
          // Change le tour
          CustomCallbackAction(callback: (globals) => _switchPlayerTurn()),
        );
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

  void _updateGameState() {
    final updater = GameStateUpdater(
        p1Circles: p1Circles,
        p2Circles: p2Circles,
        beans: beans,
        p1aabb: p1aabb,
        p2aabb: p2aabb);

    GameState newState = updater.computeGameState();

    if (null != state) {
      state!.p1pad = newState.p1pad;
      state!.p2pad = newState.p2pad;
      state!.p1points = newState.p1points;
      state!.p2points = newState.p2points;
    } else {
      state = newState;
    }
  }
}
