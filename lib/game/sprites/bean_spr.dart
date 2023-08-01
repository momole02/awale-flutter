import 'dart:async';

import 'package:flame/components.dart';

const double beanSize = 16;

class BeanSprite extends SpriteComponent {
  BeanSprite({required super.position})
      : super(size: Vector2(beanSize, beanSize));
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("bean0.png");
  }
}
