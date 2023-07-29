import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final ui.Image backgroundImage;
  late final ui.Image paddleImage;
  late final ui.Image beanImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadGameRessources();
  }

  Future<void> loadGameRessources() async {
    setState(() {
      isLoading = true;
    });
    backgroundImage = await loadImage("assets/images/bg.png");
    paddleImage = await loadImage("assets/images/paddle.png");
    beanImage = await loadImage("assets/images/bean0.png");
    setState(() {
      isLoading = false;
    });
  }

  /// Charge une image à partir du chemin [path]
  Future<ui.Image> loadImage(String path) async {
    final Completer<ui.Image> completer = Completer();
    final ByteData data = await rootBundle.load(path);
    Uint8List imageBytes = Uint8List.view(data.buffer);
    ui.decodeImageFromList(imageBytes, (ui.Image image) {
      completer.complete(image);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.orange.shade800),
                ),
              ),
            )
          : CustomPaint(
              painter: GamePainter(
                background: backgroundImage,
                paddle: paddleImage,
                bean: beanImage,
              ),
            ),
    );
  }
}

class GamePainter extends CustomPainter {
  ui.Image background;
  ui.Image paddle;
  ui.Image bean;

  GamePainter({
    required this.background,
    required this.paddle,
    required this.bean,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(background, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
