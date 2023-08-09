enum ActionState {
  idle,
  running,
  terminated,
}

/// Représente une action abstraite dans le jeu
///
abstract class Action {
  /// Etat de l'action
  ActionState state = ActionState.idle;

  /// Methode appelé lors avant de démarrer l'action
  /// i.e : avant que le state passe à running
  void onStart(Map<String, dynamic> globals) {}

  /// Effectue l'action ou une part de l'action
  void perform(List<Action> actionQueue, Map<String, dynamic> globals);

  /// Retourne le statut "terminé" de l'action
  bool get isTerminated => state == ActionState.terminated;

  /// Déclare l'action comme terminée
  void terminate() {
    state = ActionState.terminated;
  }
}

/// Classe permettant de gérer a file d'actions du jeu
class ActionManager {
  /// File d'actions
  late List<Action> queue;

  /// Variables globales
  late Map<String, dynamic> globals;

  ActionManager() {
    queue = [];
    globals = {};
  }

  /// Effectue l'action courante
  void performStuff() {
    if (queue.isNotEmpty) {
      Action top = queue[0];
      if (top.state == ActionState.idle) {
        top.state = ActionState.running;
        top.onStart(globals);
      }
      top.perform(queue, globals);
      if (top.isTerminated) {
        queue.removeAt(0);
      }
    }
  }

  /// Ajoute une nouvelle action à la file d'action
  /// Et permet un chainage d'action en retournant l'élément
  /// courant
  ActionManager push(Action action) {
    queue.add(action);
    return this;
  }

  /// Retourne vrai si des actions sont encore en cours
  bool isRunning() {
    return queue.isNotEmpty;
  }
}
