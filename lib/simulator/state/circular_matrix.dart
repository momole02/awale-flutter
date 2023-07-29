/// Classe utilitaire servant à gérer une matrice à 2 lignes
/// à indexation circulaire, optimisée pour le jeu d'awalé
class CircularMatrix {
  List<int> buffer; // Tampon global
  int rowLength; // Longueur d'une ligne
  CircularMatrix({
    required this.buffer,
    required this.rowLength,
  });

  /// Détermine le tampon associé à la matrice en fonction des
  /// deux lignes soumises
  factory CircularMatrix.from2Rows(List<int> row0, List<int> row1) {
    if (row0.length != row1.length) {
      throw Exception("Les lignes n'ont pas pas la même taille");
    }
    int rowLength = row0.length;
    return CircularMatrix(buffer: [
      ...row1,
      ...row0.reversed,
    ], rowLength: rowLength);
  }

  /// Retourne l'index circulaire
  int getCircularIndex(int row, int index) {
    if (index < 0 || index > rowLength) {
      throw Exception("Indexation en déhors des limites");
    }
    return row == 1 ? index : 2 * rowLength - 1 - index;
  }

  /// Retourne la seconde ligne de la matrice
  /// (celle du bas)
  List<int> getRow1() {
    return buffer.sublist(0, rowLength);
  }

  /// Retourne la première ligne de la matrice
  /// (celle du haut)
  List<int> getRow0() {
    return buffer.sublist(rowLength, 2 * rowLength).reversed.toList();
  }

  /// Converti un index circulaire en index matriciel
  List<int> getMatrixIndex(int circularIndex) {
    if (circularIndex >= 0 && circularIndex < rowLength) {
      return [1, circularIndex];
    } else {
      return [0, 2 * rowLength - 1 - circularIndex];
    }
  }
}
