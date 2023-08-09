import 'dart:async';

import 'package:flame/components.dart';

const double stumpSize = 110;

/// Sprite représentant une souche pour
/// garder les pions gagnés par chaque joueur
class StumpSprite extends SpriteComponent {
  StumpSprite({
    required super.position,
  }) : super(size: Vector2(stumpSize, stumpSize));

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load("stump.png");
  }
}
