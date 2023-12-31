import 'package:awale_flutter/game/gameplay/action_pattern.dart';
import 'package:flame/components.dart';

const int moveDuration = 500;

/// Implémente l'action du mouvement
/// d'un sprite d'un point à un autre image par image.
/// Le mouvement est rendu lisse par interpolation cubique
class SpriteMoveAction extends Action {
  /// Temps de debut de l'action en millsecondes
  late int _startTime;

  /// Position initiale du sprite
  late Vector2 _initialPosition;

  /// Le sprite à déplacer
  SpriteComponent sprite;

  /// La destination finale du sprite
  Vector2 location;

  SpriteMoveAction({
    required this.sprite,
    required this.location,
  });

  @override
  void onStart(Map<String, dynamic> globals) {
    _initialPosition = sprite.position;
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void perform(List<Action> actionQueue, Map<String, dynamic> globals) {
    Vector2 v0 = _initialPosition;
    Vector2 v1 = location;
    // Calcul des coefficients vectoriels
    // de l'interpolation bi-cubique
    Vector2 f0 = v0 - v1;
    Vector2 f1 = (v1 - v0) * 2;
    Vector2 f2 = v0;

    // clipping du temps sur [0,1]
    int elapsed = DateTime.now().millisecondsSinceEpoch - _startTime;
    double t = elapsed / moveDuration;

    // calcul de la position courante
    Vector2 currentPosition = f0 * t * t + f1 * t + f2;
    //Vector2 currentPosition = v0 * (1 - t) + v1 * t;
    sprite.position = currentPosition;

    // Faut faire attention à l'égalité en floating-point !
    if (currentPosition.distanceTo(location) <= 0.001) {
      // on termine l'action lorsqu'on est un assez proche
      terminate();
    }
  }
}
