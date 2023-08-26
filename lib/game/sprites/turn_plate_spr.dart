import 'dart:async';

import 'package:flame/components.dart';

class TurnPlateSprite extends SpriteComponent {
  TurnPlateSprite({required super.position});

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("turnplate.png");
  }
}
