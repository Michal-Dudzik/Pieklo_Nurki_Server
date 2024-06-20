import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final Animation<double> animation;

  const AnimatedText({
    required this.text,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final int letters = (animation.value * text.length).toInt();
        return Text(
          text.substring(0, letters),
          style: const TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontFamily: 'Lucida Console',
          ),
        );
      },
    );
  }
}
