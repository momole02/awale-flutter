import 'package:awale_flutter/game/types.dart';
import 'package:flutter/material.dart';

/// Panel de configuration du jeu
class GameConfigWidget extends StatefulWidget {
  final GameConfig initialConfig;
  final Function(GameConfig) applyConfig;
  const GameConfigWidget({
    super.key,
    required this.initialConfig,
    required this.applyConfig,
  });

  @override
  State<GameConfigWidget> createState() => _GameConfigWidgetState();
}

class _GameConfigWidgetState extends State<GameConfigWidget> {
  PlayerType? player1Type;
  PlayerType? player2Type;
  AILevel? aiLevel;

  @override
  void initState() {
    super.initState();
    player1Type = widget.initialConfig.player1;
    player2Type = widget.initialConfig.player2;
    aiLevel = widget.initialConfig.aiLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        Center(
          child: Container(
            width: 500,
            height: 350,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg0.png"),
                fit: BoxFit.contain,
              ),
            ),
            child: Column(children: [
              buildLogo(),
              buildPlayer1TypeSelector(),
              buildPlayer2TypeSelector(),
              buildAILevelSelector(),
              const Spacer(),
              buildCloseButton(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget buildPlayer1TypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: "Blackout",
          color: Colors.lime.shade900,
          fontSize: 25,
        ),
        child: Row(
          children: [
            const Expanded(child: Text("Joueur 1 :")),
            GestureDetector(
              onTap: () {
                setState(() {
                  player1Type = PlayerType.human;
                });
              },
              child: Text(
                "Humain",
                style: player1Type == PlayerType.human
                    ? TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.lime.shade900)
                    : TextStyle(
                        color: Colors.lime.shade900,
                        backgroundColor: Colors.transparent,
                      ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  player1Type = PlayerType.ai;
                });
              },
              child: Text(
                "Ia",
                style: player1Type == PlayerType.ai
                    ? TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.lime.shade900)
                    : TextStyle(
                        color: Colors.lime.shade900,
                        backgroundColor: Colors.transparent,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlayer2TypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: "Blackout",
          color: Colors.lime.shade900,
          fontSize: 25,
        ),
        child: Row(
          children: [
            const Expanded(child: Text("Joueur 2 :")),
            GestureDetector(
              onTap: () {
                setState(() {
                  player2Type = PlayerType.human;
                });
              },
              child: Text(
                "Humain",
                style: player2Type == PlayerType.human
                    ? TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.lime.shade900)
                    : TextStyle(
                        color: Colors.lime.shade900,
                        backgroundColor: Colors.transparent,
                      ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  player2Type = PlayerType.ai;
                });
              },
              child: Text(
                "Ia",
                style: player2Type == PlayerType.ai
                    ? TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.lime.shade900)
                    : TextStyle(
                        color: Colors.lime.shade900,
                        backgroundColor: Colors.transparent,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAILevelSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: "Blackout",
          color: Colors.lime.shade900,
          fontSize: 25,
        ),
        child: Row(
          children: [
            const Expanded(child: Text("Difficulte:")),
            GestureDetector(
              onTap: () {
                setState(() {
                  aiLevel = AILevel.easy;
                });
              },
              child: Text(
                "Facile",
                style: aiLevel == AILevel.easy
                    ? TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.lime.shade900)
                    : TextStyle(
                        color: Colors.lime.shade900,
                        backgroundColor: Colors.transparent,
                      ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  aiLevel = AILevel.medium;
                });
              },
              child: Text(
                "Moyen",
                style: aiLevel == AILevel.medium
                    ? TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.lime.shade900)
                    : TextStyle(
                        color: Colors.lime.shade900,
                        backgroundColor: Colors.transparent,
                      ),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  aiLevel = AILevel.hard;
                });
              },
              child: Text(
                "Difficle",
                style: aiLevel == AILevel.hard
                    ? TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.lime.shade900)
                    : TextStyle(
                        color: Colors.lime.shade900,
                        backgroundColor: Colors.transparent,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCloseButton() {
    return GestureDetector(
      onTap: () {
        widget.applyConfig(GameConfig(
            player1: player1Type!, player2: player2Type!, aiLevel: aiLevel!));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.lime.shade900,
          border: Border.all(
            color: Colors.lime.shade800,
            width: 4,
          ),
        ),
        child: const Text(
          "Fermer",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontFamily: "Blackout"),
        ),
      ),
    );
  }

  Text buildLogo() {
    return Text(
      "Awale",
      style: TextStyle(
        fontFamily: "Gilgongo",
        color: Colors.lime.shade900,
        fontSize: 45,
      ),
    );
  }
}
