import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextArrowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.0.w, right: 16.0.w),
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.red[500],
          child: Icon(Icons.arrow_forward, color: Colors.white, size: 32.w),
        ),
      ),
    );
  }
}
