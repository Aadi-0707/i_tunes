import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
  late int currentSongIndex;
  late AudioPlayer _audioPlayer;
  double progress = 0.0;
  bool isPlaying = false;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    currentSongIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();
    _configureAudio();
    _setAudio();
  }

  void _configureAudio() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          totalDuration = duration;
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        progress = position.inSeconds.toDouble();
      });
    });

    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });

      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  void _setAudio() async {
    final currentSong = widget.songs[currentSongIndex];
    final audioUrl = currentSong['audioUrl'] ?? '';
    final title = currentSong['title'] ?? 'Unknown';
    final artist = currentSong['artist'] ?? 'Unknown';
    final imageUrl = currentSong['imageUrl'] ?? '';

    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(audioUrl),
          tag: MediaItem(
            id: audioUrl,
            title: title,
            artist: artist,
            artUri: Uri.parse(imageUrl),
          ),
        ),
      );

      setState(() {
        progress = 0;
      });

      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  void playNext() {
    setState(() {
      currentSongIndex = (currentSongIndex + 1) % widget.songs.length;
    });
    _setAudio();
  }

  void playPrevious() {
    setState(() {
      currentSongIndex =
          (currentSongIndex - 1 + widget.songs.length) % widget.songs.length;
    });
    _setAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
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
    final currentSong = widget.songs[currentSongIndex];

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
            _audioPlayer.stop();
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
                    color: Colors.black.withOpacity(0.5),
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
                    value: progress,
                    min: 0.0,
                    max: totalDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        progress = value;
                      });
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
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
                  onPressed: playPrevious,
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
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.play();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, size: 35.w),
                  onPressed: playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
