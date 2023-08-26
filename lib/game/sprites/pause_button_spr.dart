import 'dart:async';

import 'package:flame/components.dart';

class PauseButtonSprite extends SpriteComponent {
  PauseButtonSprite({required super.position}) : super(size: Vector2(32, 32));

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("pause.png");
  }
}
