import 'package:flutter/material.dart';
import 'package:i_tunes/view/home_screen.dart';
import 'package:i_tunes/widget/splash_screen/dot.dart';
import 'package:i_tunes/widget/splash_screen/next_arrow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int activeIndex = 0;
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 200.w, height: 200.h),
            SizedBox(height: 30.h),
            Text(
              'My Music App',
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 30.h,
            ),
            Dot(activeIndex: activeIndex),
          ],
        ),
      ),
      floatingActionButton: NextArrowButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SecondSplashScreen(),
            ),
          );
        },
      ),
    );
  }
}

class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int activeIndex = 1;
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 200.w, height: 200.h),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Text(
                'Explore Millions of Tracks at Your Fingertips',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 30.h),
            Dot(activeIndex: activeIndex),
          ],
        ),
      ),
      floatingActionButton: NextArrowButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ThirdSplashScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ThirdSplashScreen extends StatelessWidget {
  const ThirdSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int activeIndex = 2;
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 200.w, height: 200.h),
            SizedBox(height: 30.h),
            Text(
              'Unleash the Power of Music',
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.h),
            Dot(activeIndex: activeIndex),
          ],
        ),
      ),
      floatingActionButton: NextArrowButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
