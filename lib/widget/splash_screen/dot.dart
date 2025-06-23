import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  final int activeIndex;

  const Dot({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isActive ? Colors.red : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
