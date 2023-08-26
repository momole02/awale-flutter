import 'dart:math';

import 'package:awale_flutter/simulator/state/game_state.dart';

const __infinty = 0xFFFFFFFF; // (2^32 - 1)
const __invalidMove = -100; // Mouvement invalid

class AlphaBetaContext {
  GameState currentState;
  GamePlayer mainPlayer;
  int maxDepth;

  AlphaBetaContext({
    required this.currentState,
    required this.mainPlayer,
    required this.maxDepth,
  });

  /// Retourne le meilleur mouvement à réaliser
  int guessBestMove() {
    final [move, _] =
        _min(currentState, 0, -__infinty, __infinty, __invalidMove);

    return move;
  }

  /// Retourne le joueur opposant le joueur [player]
  GamePlayer _opposite(GamePlayer player) {
    return player == GamePlayer.p1 ? GamePlayer.p2 : GamePlayer.p1;
  }

  /// Algorithme min-max couplé au hack alpha-beta
  /// [state] est l'état actuel du jeu
  /// [depth] est la profondeur
  /// [alpha] le paramètre alpha
  /// [beta] le paramètre beta
  List<int> _min(GameState state, int depth, int alpha, int beta, int moveNo) {
    int bestMoveValue = __infinty;
    int bestMoveId = __invalidMove;
    List<int> availableMoves = getAvailableMoves(state, mainPlayer);
    if (depth == maxDepth || availableMoves.isEmpty) {
      return [moveNo, state.evaluate(mainPlayer)];
    }
    for (int move in availableMoves) {
      GameState simulated = state.simulate(mainPlayer, move);
      final [_, moveValue] = _max(simulated, depth + 1, alpha, beta, move);
      if (moveValue < bestMoveValue) {
        bestMoveValue = moveValue;
        bestMoveId = move;
      }
      beta = min(beta, bestMoveValue);
      if (beta <= alpha) {
        // hack: alpha beta pruning
        break;
      }
    }
    return [bestMoveId, bestMoveValue];
  }

  /// Algorithme min-max couplé au hack alpha-beta
  /// [state] est l'état actuel du jeu
  /// [depth] est la profondeur
  /// [alpha] le paramètre alpha
  /// [beta] le paramètre beta

  List<int> _max(GameState state, int depth, int alpha, int beta, int moveNo) {
    int bestMoveValue = -__infinty;
    int bestMoveId = __invalidMove;
    GamePlayer oppositePlayer = _opposite(mainPlayer);
    List<int> availableMoves = getAvailableMoves(state, oppositePlayer);
    if (depth == maxDepth || availableMoves.isEmpty) {
      return [moveNo, state.evaluate(mainPlayer)];
    }

    for (int move in availableMoves) {
      GameState simulated = state.simulate(oppositePlayer, move);
      final [_, moveValue] = _min(simulated, depth + 1, alpha, beta, move);
      if (moveValue > bestMoveValue) {
        bestMoveValue = moveValue;
        bestMoveId = move;
      }
      alpha = max(alpha, bestMoveValue);
      if (beta <= alpha) {
        // hack: alpha beta pruning
        break;
      }
    }
    return [bestMoveId, bestMoveValue];
  }

  /// Retourne la liste des mouvement possibles rangées
  /// aléatoirement ou non
  List<int> getAvailableMoves(GameState state, GamePlayer player) {
    List<int> moves = state.getAvailableMoves(player);
    return moves;
  }
}
