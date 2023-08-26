import 'package:awale_flutter/game/awale_game.dart';
import 'package:awale_flutter/game/constants.dart';
import 'package:awale_flutter/game/overlays/game_config_widget.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  Flame.device.setLandscape();
  Flame.device.fullScreen();

  final game = AwaleGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        kPauseOverlayId: (BuildContext context, AwaleGame game) {
          return GameConfigWidget(
            initialConfig: game.gameConfig,
            applyConfig: (config) {
              game.gameConfig = config;
              game.unpauseGame(); // Enlever le jeu en pause
            },
          );
        }
      },
    ),
  );
}
