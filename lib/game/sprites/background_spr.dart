import 'dart:async';

import 'package:flame/components.dart';

class BackgroundSprite extends SpriteComponent {
  BackgroundSprite({Vector2? size}) : super(size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("bg.png");
  }
}
