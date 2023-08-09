import 'dart:math';

import 'package:flame/game.dart';

/// Retourne une position aléatoire au sein d'un AABB
Vector2 randomAABBPostion(Aabb2 aabb2) {
  final rnd = Random();
  double yMax = 1 + aabb2.max.y - aabb2.min.y;
  double xMax = 1 + aabb2.max.x - aabb2.min.x;
  double yMin = aabb2.min.y;
  double xMin = aabb2.min.x;
  return Vector2(
    rnd.nextDouble() * xMax + xMin,
    rnd.nextDouble() * yMax + yMin,
  );
}
