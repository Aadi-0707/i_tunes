import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:i_tunes/view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.itunes.audio',
      androidNotificationChannelName: 'iTunes Playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(MyApp(audioHandler: audioHandler));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.audioHandler});
  final AudioPlayerHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'iTunes Music Player',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
            useMaterial3: true,
          ),
          home: AudioServiceWidget(
              child: SplashScreen(audioHandler: audioHandler)),
        );
      },
    );
  }
}
