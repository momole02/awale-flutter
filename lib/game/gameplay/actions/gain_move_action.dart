import 'package:awale_flutter/game/gameplay/action_pattern.dart';
import 'package:awale_flutter/game/gameplay/actions/sprite_move_action.dart';
import 'package:awale_flutter/game/utils.dart';
import 'package:flame/components.dart';

/// Implémentation du gain d'un joueur
/// i.e: déplacement des pions depuis le cercle
/// d'un joueur vers les gains d'un autre joueur
class GainMoveAction extends Action {
  Aabb2 playerCircle;
  Aabb2 gainCircle;
  List<SpriteComponent> beans;

  late List<SpriteComponent> _playerBeans;

  GainMoveAction({
    required this.playerCircle,
    required this.gainCircle,
    required this.beans,
  });

  @override
  void onStart(Map<String, dynamic> globals) {
    _playerBeans = beans
        .where((bean) => playerCircle.containsVector2(bean.position))
        .toList();
  }

  @override
  void perform(List<Action> actionQueue, Map<String, dynamic> globals) {
    List<Action> moves = [];
    for (int i = 0; i < _playerBeans.length; ++i) {
      moves.add(SpriteMoveAction(
        sprite: _playerBeans[i],
        location: randomAABBPostion(gainCircle),
      ));
    }
    actionQueue.insertAll(1, moves);
    terminate();
  }
}
