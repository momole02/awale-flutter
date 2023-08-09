import 'dart:math';

import 'package:awale_flutter/game/gameplay/action_pattern.dart';
import 'package:awale_flutter/game/gameplay/actions/sprite_move_action.dart';
import 'package:awale_flutter/game/gameplay/actions/symbols.dart';
import 'package:flame/components.dart';

/// Implémentation de l'action associé au jeu d'un joueur
/// i.e: le déplacement de ses pions cases par case
class PlayerMoveAction extends Action {
  /// Liste des AABBs associées aux cercles du joueur 1
  List<Aabb2> p1Circles;

  /// Liste des AABBs associées aux cercles du joueur 2
  List<Aabb2> p2Circles;

  /// Liste de toutes les graines
  List<SpriteComponent> beans;

  /// Durée du mouvement d'une graine
  int beanMoveDuration;

  /// AABB choisie
  Aabb2 playCircle;

  /// Liste des graines présentes dans le cercle choisi
  late List<SpriteComponent> _currentCircleBeans;

  /// Liste circulaire des cercles
  late List<Aabb2> _circular;

  /// Index de la AABB choisie dans la liste circulaire
  late int _initialPlayIndex;

  /// Index de la prochaine destination de la graine
  late int _nextPlayIndex;

  PlayerMoveAction({
    required this.p1Circles,
    required this.p2Circles,
    required this.beans,
    required this.playCircle,
    this.beanMoveDuration = 2000,
  });
  @override
  void onStart(Map<String, dynamic> globals) {
    _circular = [
      ...p2Circles,
      ...p1Circles.reversed,
    ];
    _initialPlayIndex = _circular.indexWhere((aabb) => aabb == playCircle);
    if (-1 == _initialPlayIndex) {
      throw Exception("AABB associé au jeu non trouvée");
    }
    // determiner les graines contenues dans le cercle choisi
    _currentCircleBeans = beans
        .where((bean) => playCircle.containsVector2(bean.position))
        .toList();

    // ... la prochaine destination de la graine
    _nextPlayIndex = (1 + _initialPlayIndex) % _circular.length;

    /// Enregistrer l'index circulaire initial
    /// Pour le retrait des gains
    globals[kLastPlayStartIndex] = _initialPlayIndex;
    globals[kLastPlayCount] = _currentCircleBeans.length;
  }

  @override
  void perform(List<Action> actionQueue, Map<String, dynamic> globals) {
    final List<Action> beanMoves = [];

    /// Ajouter les actions relatives au mouvement de chaque graine
    for (int i = 0; i < _currentCircleBeans.length;) {
      if (i != 0 && _initialPlayIndex == _nextPlayIndex) {
        // si on retombe sur le même cercle
        // à partir duquel on a déja joué
        // on saute
        _nextPlayIndex = (1 + _nextPlayIndex) % _circular.length;

        continue;
      }
      Aabb2 target = _circular[_nextPlayIndex];
      beanMoves.add(
        SpriteMoveAction(
          sprite: _currentCircleBeans[i],
          location: _aabbRandomPosition(target),
        ),
      );
      _nextPlayIndex = (1 + _nextPlayIndex) % _circular.length;
      ++i;
    }

    /// Planifier le mouvement des graines
    actionQueue.insertAll(1, beanMoves);

    /// Mettre fin à l'action afin de passer le relais au mouvement
    terminate();
  }

  /// Retourne une position aléatoire au sein d'une AABB
  Vector2 _aabbRandomPosition(Aabb2 aabb) {
    const double delta = 10;
    final rnd = Random();
    return Vector2(
      aabb.min.x + rnd.nextDouble() * (1 + aabb.max.x - aabb.min.x - delta),
      aabb.min.y + rnd.nextDouble() * (1 + aabb.max.y - aabb.min.y - delta),
    );
  }
}
