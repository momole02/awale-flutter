import 'dart:async';
import 'dart:ui';

import 'package:awale_flutter/game/sprites/background_spr.dart';
import 'package:awale_flutter/game/sprites/paddle_spr.dart';

import 'package:flame/game.dart';

class AwaleGame extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    addAll([
      BackgroundSprite(size: Vector2(size.x, size.y)),
      PaddleSprite(position: Vector2(size.x / 10, size.y / 4)),
    ]);
  }
}
