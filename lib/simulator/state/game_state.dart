import 'package:awale_flutter/simulator/state/circular_matrix.dart';

class GameStateException implements Exception {
  String? message;
  GameStateException(this.message);

  @override
  String toString() {
    return message ?? "Erreur / etat de jeu";
  }
}

/// Enumération représentant les joueurs du jeu
enum GamePlayer {
  p1,
  p2,
}

/// Represente un état du jeu awalé
class GameState {
  /// Liste des cercles contenant les pions en face du joueur 1
  List<int> p1pad;

  /// Liste des cercles contenant les pions en face du joueur 2
  List<int> p2pad;

  /// Gains du joueur 1
  int p1points;

  /// Gains du joueur 2
  int p2points;

  GameState({
    required this.p1pad,
    required this.p2pad,
    required this.p1points,
    required this.p2points,
  });

  /// Retourne l'état de debut du jeu
  factory GameState.start(int length) {
    return GameState(
        p1pad: List.generate(length, (index) => 4),
        p2pad: List.generate(length, (index) => 4),
        p1points: 0,
        p2points: 0);
  }

  /// Effectue un jeu pour le joueur [player] à l'emplacement [cavityIndex]
  /// Sur un jeu ayant pour matrice circulaire [circularMatrix]
  /// Et retourne le dernier emplacement
  int _distributeHand(
    CircularMatrix circularMatrix,
    GamePlayer player,
    int cavityIndex,
  ) {
    int row = player == GamePlayer.p1 ? 0 : 1;
    int startIndex = circularMatrix.getCircularIndex(row, cavityIndex);
    int hand = circularMatrix.buffer[startIndex];
    circularMatrix.buffer[startIndex] = 0;
    int index = startIndex;

    // Distribuer la main en sautant la case de début
    while (hand != 0) {
      index = (index + 1) % circularMatrix.buffer.length;
      if (index != startIndex) {
        circularMatrix.buffer[index]++;
        hand--;
      }
    }

    return index;
  }

  /// Determine les gains du joueur [player] ayant joué, à partir du dernier index [lastIndex] et
  /// de la dernière ligne [lastRow].
  /// Et retourne une liste avec
  /// [0] => les gains du joueur 1
  /// [1] => les gains du joueur 2
  List<int> _computeGains(
    CircularMatrix circularMatrix,
    GamePlayer player,
    int lastCircularIndex,
  ) {
    int index = lastCircularIndex;
    final [lastRow, _] = circularMatrix.getMatrixIndex(lastCircularIndex);
    int gains = 0;

    // retourne vrai si la position est gagnante
    isGaining(int idx) =>
        circularMatrix.buffer[idx] == 2 || circularMatrix.buffer[idx] == 3;
    // Le premier joueur termine t-il sur la zone du second joueur ?
    bool isPlayer1Jackpot = player == GamePlayer.p1 && lastRow == 1;

    // Le second joueur termine t-il sur la zone du premier joueur ?
    bool isPlayer2Jackpot = player == GamePlayer.p2 && lastRow == 0;

    if (!isPlayer1Jackpot && !isPlayer2Jackpot) {
      return [0, 0];
    }

    bool sameRow = true;
    bool gaining = true;
    do {
      final [row, _] = circularMatrix.getMatrixIndex(index);
      sameRow = row == lastRow;
      gaining = isGaining(index);
      if (sameRow && gaining) {
        gains += circularMatrix.buffer[index];
        circularMatrix.buffer[index] = 0;
        --index;
        if (index < 0) {
          // si on sors par le debut on retourne à la fin
          index = circularMatrix.buffer.length - 1;
        }
      }
    } while (sameRow && gaining);
    return [
      isPlayer1Jackpot ? gains : 0,
      isPlayer2Jackpot ? gains : 0,
    ];
  }

  /// Effectue la simulation d'un jeu du joueur [player]
  /// Dans la cavité ayant pour index [cavityIndex]
  /// et retourne le nouvel état de jeu
  GameState simulate(GamePlayer player, int cavityIndex) {
    CircularMatrix circularMatrix = CircularMatrix.from2Rows(p1pad, p2pad);

    // Distribuer la main
    int lastCircularIndex =
        _distributeHand(circularMatrix, player, cavityIndex);
    // Recupérer les gains
    final [p1gains, p2gains] =
        _computeGains(circularMatrix, player, lastCircularIndex);

    return GameState(
      p1pad: circularMatrix.getRow0(),
      p2pad: circularMatrix.getRow1(),
      p1points: p1points + p1gains,
      p2points: p2points + p2gains,
    );
  }

  /// Evalue t'état du jeu par rapport au joueur [mainPlayer]
  /// et retourne un resultat par rapport à l'opposant
  int evaluate([GamePlayer mainPlayer = GamePlayer.p1]) {
    return mainPlayer == GamePlayer.p1
        ? p2points - p1points
        : p1points - p2points;
  }

  /// Retourne les mouvements possibles pour le joueur [player]
  List<int> getAvailableMoves(GamePlayer player) {
    if (player == GamePlayer.p1) {
      return List.generate(p1pad.length, (index) => index)
          .where((index) => p1pad[index] > 0)
          .toList();
    } else {
      return List.generate(p2pad.length, (index) => index)
          .where((index) => p2pad[index] > 0)
          .toList();
    }
  }

  /// Retourne vrai si le jeu est équilibré
  // bool isBalanced() {
  //   const expectedTotal = 2 * 8 * 8;
  //   int p1padTotal = p1pad.reduce((value, element) => value + element);
  //   int p2padTotal = p2pad.reduce((value, element) => value + element);
  //   final total = p1points + p2points + p1padTotal + p2padTotal;
  //   return expectedTotal == total;
  // }
}
