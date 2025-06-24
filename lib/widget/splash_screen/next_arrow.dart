import 'package:flutter/material.dart';

class NextArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextArrowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0, right: 16.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.arrow_forward, size: 32),
        ),
      ),
    );
  }
}
