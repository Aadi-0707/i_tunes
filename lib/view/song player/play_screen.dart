import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/widget/audio_handler.dart';
import 'package:audio_service/audio_service.dart';

class PlayScreen extends StatefulWidget {
  final List<Map<String, String>> songs;
  final int initialIndex;

  const PlayScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  MyAudioHandler? handler;
  double progress = 0.0;
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;
  int currentIndex = 0;
  bool isSeekingFromSlider = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _setupAudioService();
  }

  Future<void> _setupAudioService() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    handler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
        androidResumeOnClick: true,
        androidStopForegroundOnPause: true,
        androidNotificationChannelId: 'com.example.i_tunes.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
      ),
    );

    // Create MediaItems from songs
    final items = widget.songs.map((song) {
      return MediaItem(
        id: song['audioUrl']!,
        title: song['title'] ?? 'Unknown',
        artist: song['artist'] ?? 'Unknown',
        artUri: Uri.parse(song['imageUrl'] ?? ''),
      );
    }).toList();

    // Load the queue
    await handler?.loadQueue(items, startIndex: widget.initialIndex);

    // Listen to player streams
    _setupPlayerListeners();

    // Start playing
    await handler?.play();
  }

  void _setupPlayerListeners() {
    if (handler == null) return;

    // Listen to duration changes
    handler!.player.durationStream.listen((duration) {
      if (duration != null && mounted) {
        setState(() {
          totalDuration = duration;
          // Reset progress if it exceeds new duration
          if (progress > duration.inSeconds.toDouble()) {
            progress = 0.0;
          }
        });
      }
    });

    // Listen to position changes
    handler!.player.positionStream.listen((position) {
      if (mounted && !isSeekingFromSlider) {
        setState(() => progress = position.inSeconds.toDouble());
      }
    });

    // Listen to player state changes
    handler!.player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() => isPlaying = state.playing);
      }
    });

    // Listen to current index changes
    handler!.player.currentIndexStream.listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
          // Reset progress when song changes
          progress = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    // Don't dispose the handler here as it should continue running
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songs[currentIndex];

    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent[50],
        elevation: 0,
        title: const Text('Playing', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(340.r),
                image: DecorationImage(
                  image: NetworkImage(currentSong['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(128),
                    blurRadius: 20.r,
                    offset: Offset(0, 15.h),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              currentSong['title'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              currentSong['artist'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  _formatTime(Duration(seconds: progress.toInt())),
                  style: const TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Slider(
                    value: totalDuration.inSeconds > 0
                        ? progress.clamp(
                            0.0, totalDuration.inSeconds.toDouble())
                        : 0.0,
                    min: 0.0,
                    max: totalDuration.inSeconds > 0
                        ? totalDuration.inSeconds.toDouble()
                        : 1.0,
                    onChangeStart: (value) {
                      isSeekingFromSlider = true;
                    },
                    onChanged: (value) {
                      setState(() => progress = value);
                    },
                    onChangeEnd: (value) {
                      isSeekingFromSlider = false;
                      handler?.seek(Duration(seconds: value.toInt()));
                    },
                    activeColor: Colors.red,
                  ),
                ),
                Text(
                  _formatTime(totalDuration),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, size: 35.w),
                  onPressed: handler?.skipToPrevious,
                ),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.red,
                    size: 60.w,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      handler?.pause();
                    } else {
                      handler?.play();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, size: 35.w),
                  onPressed: handler?.skipToNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:audio_service/audio_service.dart';

// class PlayScreen extends StatefulWidget {
//   final List<Map<String, String>> songs;
//   final int initialIndex;

//   const PlayScreen({
//     super.key,
//     required this.songs,
//     required this.initialIndex,
//   });

//   @override
//   State<PlayScreen> createState() => _PlayScreenState();
// }

// class _PlayScreenState extends State<PlayScreen> {
//   late AudioPlayer _audioPlayer;
//   double progress = 0.0;
//   bool isPlaying = false;
//   Duration totalDuration = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _setupAudio();
//   }

//   Future<void> _setupAudio() async {
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.music());

//     _audioPlayer.durationStream.listen((duration) {
//       if (duration != null) {
//         setState(() => totalDuration = duration);
//       }
//     });

//     _audioPlayer.positionStream.listen((position) {
//       setState(() => progress = position.inSeconds.toDouble());
//     });

//     _audioPlayer.playerStateStream.listen((state) {
//       setState(() => isPlaying = state.playing);
//     });

//     final playlist = ConcatenatingAudioSource(
//       children: widget.songs.map((song) {
//         return AudioSource.uri(
//           Uri.parse(song['audioUrl'] ?? ''),
//           tag: MediaItem(
//             id: song['audioUrl']!,
//             title: song['title'] ?? 'Unknown',
//             artist: song['artist'] ?? 'Unknown',
//             artUri: Uri.parse(song['imageUrl'] ?? ''),
//           ),
//         );
//       }).toList(),
//     );

//     await _audioPlayer.setLoopMode(LoopMode.all);
//     await _audioPlayer.setAudioSource(playlist,
//         initialIndex: widget.initialIndex);
//     await _audioPlayer.play();
//   }

//   void _playNext() => _audioPlayer.seekToNext();
//   void _playPrevious() => _audioPlayer.seekToPrevious();
//   @override
//   void stop() => _audioPlayer.pause();

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   String _formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentSong =
//         widget.songs[_audioPlayer.currentIndex ?? widget.initialIndex];

//     return Scaffold(
//       backgroundColor: Colors.redAccent[50],
//       appBar: AppBar(
//         backgroundColor: Colors.redAccent[50],
//         elevation: 0,
//         title: const Text('Playing', style: TextStyle(color: Colors.black)),
//         leading: IconButton(
//           icon:
//               const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
//           onPressed: () {
//             _audioPlayer.stop();
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.h),
//         child: Column(
//           children: [
//             SizedBox(height: 30.h),
//             Container(
//               height: 350,
//               width: 350,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(340.r),
//                 image: DecorationImage(
//                   image: NetworkImage(currentSong['imageUrl'] ?? ''),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withAlpha(128),
//                     blurRadius: 20.r,
//                     offset: Offset(0, 15.h),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30.h),
//             Text(
//               currentSong['title'] ?? '',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               currentSong['artist'] ?? '',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               children: [
//                 Text(
//                   _formatTime(Duration(seconds: progress.toInt())),
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//                 Expanded(
//                   child: Slider(
//                     value: progress,
//                     min: 0.0,
//                     max: totalDuration.inSeconds.toDouble(),
//                     onChanged: (value) {
//                       setState(() => progress = value);
//                       _audioPlayer.seek(Duration(seconds: value.toInt()));
//                     },
//                     activeColor: Colors.red,
//                   ),
//                 ),
//                 Text(
//                   _formatTime(totalDuration),
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.skip_previous, size: 35.w),
//                   onPressed: _playPrevious,
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     isPlaying
//                         ? Icons.pause_circle_filled
//                         : Icons.play_circle_fill,
//                     color: Colors.red,
//                     size: 60.w,
//                   ),
//                   onPressed: () {
//                     if (isPlaying) {
//                       _audioPlayer.pause();
//                     } else {
//                       _audioPlayer.play();
//                     }
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.skip_next, size: 35.w),
//                   onPressed: _playNext,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // import 'package:audio_session/audio_session.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:just_audio_background/just_audio_background.dart';
// // import 'package:audio_service/audio_service.dart';

// // class PlayScreen extends StatefulWidget {
// //   final List<Map<String, String>> songs;
// //   final int initialIndex;

// //   const PlayScreen({
// //     super.key,
// //     required this.songs,
// //     required this.initialIndex,
// //   });

// //   @override
// //   State<PlayScreen> createState() => _PlayScreenState();
// // }

// // class _PlayScreenState extends State<PlayScreen> {
// //   late AudioPlayer _audioPlayer;
// //   double progress = 0.0;
// //   bool isPlaying = false;
// //   Duration totalDuration = Duration.zero;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _audioPlayer = AudioPlayer();
// //     _setupAudio();
// //   }

// //   Future<void> _setupAudio() async {
// //     final session = await AudioSession.instance;
// //     await session.configure(AudioSessionConfiguration.music());

// //     _audioPlayer.durationStream.listen((duration) {
// //       if (duration != null) {
// //         setState(() => totalDuration = duration);
// //       }
// //     });

// //     _audioPlayer.positionStream.listen((position) {
// //       setState(() => progress = position.inSeconds.toDouble());
// //     });

// //     _audioPlayer.playerStateStream.listen((state) {
// //       setState(() => isPlaying = state.playing);
// //     });

// //     final playlist = ConcatenatingAudioSource(
// //       children: widget.songs.map((song) {
// //         return AudioSource.uri(
// //           Uri.parse(song['audioUrl'] ?? ''),
// //           tag: MediaItem(
// //             id: song['audioUrl']!,
// //             title: song['title'] ?? 'Unknown',
// //             artist: song['artist'] ?? 'Unknown',
// //             artUri: Uri.parse(song['imageUrl'] ?? ''),
// //           ),
// //         );
// //       }).toList(),
// //     );

// //     await _audioPlayer.setLoopMode(LoopMode.all);
// //     await _audioPlayer.setAudioSource(playlist,
// //         initialIndex: widget.initialIndex);
// //     await _audioPlayer.play();

// //   }

// //   void _playNext() => _audioPlayer.seekToNext();
// //   void _playPrevious() => _audioPlayer.seekToPrevious();

// //   @override
// //   void dispose() {
// //     _audioPlayer.dispose();
// //     super.dispose();
// //   }

// //   String _formatTime(Duration duration) {
// //     String twoDigits(int n) => n.toString().padLeft(2, "0");
// //     final minutes = twoDigits(duration.inMinutes.remainder(60));
// //     final seconds = twoDigits(duration.inSeconds.remainder(60));
// //     return "$minutes:$seconds";
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final currentSong =
// //         widget.songs[_audioPlayer.currentIndex ?? widget.initialIndex];

// //     return Scaffold(
// //       backgroundColor: Colors.redAccent[50],
// //       appBar: AppBar(
// //         backgroundColor: Colors.redAccent[50],
// //         elevation: 0,
// //         title: const Text('Playing', style: TextStyle(color: Colors.black)),
// //         leading: IconButton(
// //           icon:
// //               const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
// //           onPressed: () {
// //             _audioPlayer.stop();
// //             Navigator.pop(context);
// //           },
// //         ),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.h),
// //         child: Column(
// //           children: [
// //             SizedBox(height: 30.h),
// //             Container(
// //               height: 350,
// //               width: 350,
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(340.r),
// //                 image: DecorationImage(
// //                   image: NetworkImage(currentSong['imageUrl'] ?? ''),
// //                   fit: BoxFit.cover,
// //                 ),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withAlpha(128),
// //                     blurRadius: 20.r,
// //                     offset: Offset(0, 15.h),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             SizedBox(height: 30.h),
// //             Text(
// //               currentSong['title'] ?? '',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 4.h),
// //             Text(
// //               currentSong['artist'] ?? '',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
// //             ),
// //             SizedBox(height: 20.h),
// //             Row(
// //               children: [
// //                 Text(
// //                   _formatTime(Duration(seconds: progress.toInt())),
// //                   style: const TextStyle(color: Colors.grey),
// //                 ),
// //                 Expanded(
// //                   child: Slider(
// //                     value: progress,
// //                     min: 0.0,
// //                     max: totalDuration.inSeconds.toDouble(),
// //                     onChanged: (value) {
// //                       setState(() => progress = value);
// //                       _audioPlayer.seek(Duration(seconds: value.toInt()));
// //                     },
// //                     activeColor: Colors.red,
// //                   ),
// //                 ),
// //                 Text(
// //                   _formatTime(totalDuration),
// //                   style: const TextStyle(color: Colors.grey),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 20.h),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //               children: [
// //                 IconButton(
// //                   icon: Icon(Icons.skip_previous, size: 35.w),
// //                   onPressed: _playPrevious,
// //                 ),
// //                 IconButton(
// //                   icon: Icon(
// //                     isPlaying
// //                         ? Icons.pause_circle_filled
// //                         : Icons.play_circle_fill,
// //                     color: Colors.red,
// //                     size: 60.w,
// //                   ),
// //                   onPressed: () {
// //                     if (isPlaying) {
// //                       _audioPlayer.pause();
// //                     } else {
// //                       _audioPlayer.play();
// //                     }
// //                   },
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.skip_next, size: 35.w),
// //                   onPressed: _playNext,
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
