import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextArrowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.0.h, right: 16.0.w),
      child: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/music_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Icon(Icons.arrow_forward_ios_outlined,
                color: Colors.white, size: 24.w),
          ),
        ),
      ),
    );
  }
}
