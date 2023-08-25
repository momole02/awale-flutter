import 'package:awale_flutter/game/gameplay/action_pattern.dart';
import 'package:awale_flutter/game/gameplay/actions/gain_move_action.dart';
import 'package:awale_flutter/game/constants.dart';
import 'package:awale_flutter/simulator/state/circular_matrix.dart';
import 'package:awale_flutter/simulator/state/game_state.dart';
import 'package:flame/components.dart';

const vPlayer1Row = 0;
const vPlayer2Row = 1;

/// Implémentation de l'action associé au retrait
/// des gains après un jeu
class GainsTakingAction extends Action {
  GameState gameState;
  List<Aabb2> p1Circles;
  List<Aabb2> p2Circles;
  Aabb2 p1aabb;
  Aabb2 p2aabb;
  List<SpriteComponent> beans;

  late List<Aabb2> _circular;
  late CircularMatrix _circularMatrix;
  late int _lastPlayStartIndex;
  late int _lastPlayCount;

  GainsTakingAction({
    required this.gameState,
    required this.p1Circles,
    required this.p2Circles,
    required this.beans,
    required this.p1aabb,
    required this.p2aabb,
  });

  @override
  void onStart(Map<String, dynamic> globals) {
    _circular = [...p2Circles, ...p1Circles.reversed];
    _circularMatrix =
        CircularMatrix.from2Rows(gameState.p1pad, gameState.p2pad);
    _lastPlayStartIndex = globals[kLastPlayStartIndex] as int;
    _lastPlayCount = globals[kLastPlayCount];
  }

  @override
  void perform(List<Action> actionQueue, Map<String, dynamic> globals) {
    final [startRow, _] = _circularMatrix.getMatrixIndex(_lastPlayStartIndex);
    int lastIndex =
        (_lastPlayStartIndex + _lastPlayCount) % _circularMatrix.buffer.length;
    final [lastRow, _] = _circularMatrix.getMatrixIndex(lastIndex);

    int currentIndex = lastIndex;
    int currentRow = lastRow;
    bool isGaining = _gaining(_circularMatrix.buffer[currentIndex]);
    List<Action> moves = [];
    while (currentRow != startRow && isGaining) {
      moves.add(
        GainMoveAction(
          playerCircle: _circular[currentIndex],
          gainCircle: startRow == vPlayer1Row ? p1aabb : p2aabb,
          beans: beans,
        ),
      );
      --currentIndex;
      if (currentIndex < 0) {
        currentIndex = _circularMatrix.buffer.length - 1;
      }
      isGaining = _gaining(_circularMatrix.buffer[currentIndex]);
      final [row, _] = _circularMatrix.getMatrixIndex(currentIndex);
      currentRow = row;
    }

    if (moves.isNotEmpty) {
      actionQueue.insertAll(1, moves);
    }
    terminate();
  }

  bool _gaining(int value) => value == 2 || value == 3;
}
