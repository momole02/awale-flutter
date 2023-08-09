import 'package:awale_flutter/game/gameplay/action_pattern.dart';

/// Action permettant l'implémentation d'un callback custom
class CustomCallbackAction extends Action {
  /// Callback
  Function(Map<String, dynamic>) callback;

  CustomCallbackAction({required this.callback});

  @override
  void perform(List<Action> actionQueue, Map<String, dynamic> globals) {
    callback(globals);
    terminate();
  }
}
