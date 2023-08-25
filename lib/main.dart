import 'package:awale_flutter/game/awale_game.dart';
import 'package:awale_flutter/game/constants.dart';
import 'package:awale_flutter/game/overlays/game_config_widget.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();

  runApp(
    GameWidget(
      game: AwaleGame(),
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
