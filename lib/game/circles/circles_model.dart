/// Modèle associé au fichier JSON contenant les
/// AABB des cercles
class CirclesModel {
  ///AABBs des cercles du joueur 1
  List<List<int>> player1;

  /// AABBs des cercles du joueur 2
  List<List<int>> player2;

  CirclesModel({
    required this.player1,
    required this.player2,
  });

  factory CirclesModel.fromJson(Map<String, dynamic> data) {
    return CirclesModel(
      player1: data["player1"]
          .map<List<int>>(
              (l) => (l.map<int>((m) => m as int).toList()) as List<int>)
          .toList(),
      player2: data["player2"]
          .map<List<int>>(
              (l) => (l.map<int>((m) => m as int).toList()) as List<int>)
          .toList(),
    );
  }
}
