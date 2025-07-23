import 'package:flutter/material.dart';
import 'package:i_tunes/view/Bottom_screen/Bottom_controller/bottom_bar.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:i_tunes/view/Splash/Widget/dot.dart';
import 'package:i_tunes/view/Splash/Widget/next_arrow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  final AudioPlayerHandler audioHandler;

  const SplashScreen({super.key, required this.audioHandler});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int activeIndex = 0;

  final List<String> splashTexts = [
    'My Music App',
    'Explore Millions of Tracks at Your Fingertips',
    'Unleash the Power of Music',
  ];

  void _nextPage() {
    if (activeIndex < 2) {
      setState(() {
        activeIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => BottomBar(audioHandler: widget.audioHandler)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/logo.png',
                width: 200.w, height: 200.h),
          ),
          SizedBox(),
          Center(
            child: Container(
              width: 320.w,
              height: 80.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              decoration: BoxDecoration(
                color: Colors.redAccent[50],
              ),
              child: Text(
                splashTexts[activeIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 60.h),
          Dot(activeIndex: activeIndex),
        ],
      ),
      floatingActionButton: NextArrowButton(onPressed: _nextPage),
    );
  }
}
