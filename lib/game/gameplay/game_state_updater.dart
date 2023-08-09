import 'package:awale_flutter/simulator/state/game_state.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Classe utilitaire permettant de mettre à jour l'état du jeu
///
class GameStateUpdater {
  /// Cercles du joueur 1
  List<Aabb2> p1Circles;

  /// Cercles du joueur 2
  List<Aabb2> p2Circles;

  /// Liste des pions
  List<SpriteComponent> beans;

  /// AABB contenant les pions gagnés par le joueur 1
  Aabb2 p1aabb;

  /// AABB contenant les pions gagnés par le joueur 2
  Aabb2 p2aabb;

  GameStateUpdater({
    required this.p1Circles,
    required this.p2Circles,
    required this.beans,
    required this.p1aabb,
    required this.p2aabb,
  });

  GameState computeGameState() {
    return GameState(
      /// Determiner le nombre pions dans chacun des cercles du joueur 1
      p1pad: p1Circles
          .map<int>((circle) => beans
              .where((bean) => circle.containsVector2(bean.position))
              .length)
          .toList(),

      /// Determiner le nombre pions dans chacun des cercles du joueur 2
      p2pad: p2Circles
          .map<int>((circle) => beans
              .where((bean) => circle.containsVector2(bean.position))
              .length)
          .toList(),

      /// Determiner le nombre de pions dans la souche du joueur 1
      p1points:
          beans.where((bean) => p1aabb.containsVector2(bean.position)).length,

      /// Determiner le nombre de pions dans la souche joueur 2
      p2points:
          beans.where((bean) => p2aabb.containsVector2(bean.position)).length,
    );
  }
}
