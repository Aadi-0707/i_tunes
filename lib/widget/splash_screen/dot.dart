import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          duration: Duration(milliseconds: 10),
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: isActive ? Colors.red : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
