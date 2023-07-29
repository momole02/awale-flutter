import 'package:awale_flutter/game/awale_game.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();

  runApp(
    GameWidget(
      game: AwaleGame(),
    ),
  );
}
