/// Nombre de cercles par joueur sur le plateau
const int circlesPerPlayer = 7;

/// Décalage Y utilisé pour le calcul des AABBs des
/// cercles sur le plateau
const double circleDeltaY = 0;

/// Decalage utilisé pour calculer les AABBs des
/// différentes souches des gains
const double stumpOffset = 20;

/// Définition des joueurs
///
enum Player {
  player1,
  player2,
}

/// Types de joueur AI / Humain
enum PlayerType {
  ai,
  human,
}

/// Niveau de l'IA Facile / Moyen / Difficle
enum AILevel {
  easy,
  medium,
  hard,
}

/// Configuration du jeu
class GameConfig {
  PlayerType player1;
  PlayerType player2;
  AILevel aiLevel;
  GameConfig({
    required this.player1,
    required this.player2,
    required this.aiLevel,
  });
}
