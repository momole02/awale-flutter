import 'package:awale_flutter/simulator/state/game_state.dart';
import 'package:flutter/material.dart';

/// Overlay de fin de jeu
class GameOverWidget extends StatefulWidget {
  final GameState state;
  final Function() onRestart;
  const GameOverWidget({
    super.key,
    required this.state,
    required this.onRestart,
  });

  @override
  State<GameOverWidget> createState() => _GameOverWidgetState();
}

class _GameOverWidgetState extends State<GameOverWidget> {
  GamePlayer? winner;

  @override
  void initState() {
    super.initState();
    winner = widget.state.hasWinner();
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
            child: DefaultTextStyle(
              style: const TextStyle(
                fontFamily: "Blackout",
                fontSize: 25,
                color: Colors.black,
              ),
              child: Column(
                children: [
                  buildLogo(),
                  const SizedBox(height: 60),
                  if (winner == GamePlayer.p1)
                    const Text("Le joueur 1 à remporté la partie"),
                  if (winner == GamePlayer.p2)
                    const Text("Le joueur 2 à remporté la partie"),
                  const Spacer(),
                  buildCloseButton(),
                ],
              ),
            ),
          ),
        )
      ],
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

  Widget buildCloseButton() {
    return GestureDetector(
      onTap: () {
        widget.onRestart();
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
          "Rejouer",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontFamily: "Blackout"),
        ),
      ),
    );
  }
}
