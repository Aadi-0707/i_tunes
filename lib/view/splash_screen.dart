import 'package:flutter/material.dart';
import 'package:i_tunes/view/home_screen.dart';
import 'package:i_tunes/widget/splash_screen/dot.dart';
import 'package:i_tunes/widget/splash_screen/next_arrow.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int activeIndex = 0;
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 200, height: 200),
            const SizedBox(height: 30),
            const Text(
              'My Music App',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 30,
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
      backgroundColor: Colors.red[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 200, height: 200),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Explore Millions of Tracks at Your Fingertips',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 30),
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
      backgroundColor: Colors.red[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 200, height: 200),
            const SizedBox(height: 30),
            const Text(
              'Unleash the Power of Music',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
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
