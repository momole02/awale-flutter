import 'dart:async';

import 'package:flame/components.dart';

class PaddleSprite extends SpriteComponent {
  PaddleSprite({super.position});
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("paddle.png");
  }
}
