import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

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

class _PlayScreenState extends State<PlayScreen> with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentIndex = 0;

  late StreamSubscription<PlayerState> _playerStateSub;
  late StreamSubscription<Duration> _positionSub;
  late StreamSubscription<Duration?> _durationSub;
  late StreamSubscription<int?> _currentIndexSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = widget.initialIndex;
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    final playlist = ConcatenatingAudioSource(
      children: widget.songs.map((song) {
        return AudioSource.uri(
          Uri.parse(song['audioUrl'] ?? ''),
          tag: MediaItem(
            id: song['audioUrl']!,
            title: song['title'] ?? 'Unknown',
            artist: song['artist'] ?? 'Unknown',
            artUri: Uri.parse(song['imageUrl'] ?? ''),
          ),
        );
      }).toList(),
    );

    await _audioPlayer.setAudioSource(playlist,
        initialIndex: widget.initialIndex);
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.play();

    _listenToStreams();
  }

  void _listenToStreams() {
    _playerStateSub =
        _audioPlayer.playerStateStream.listen((_) => setState(() {}));
    _positionSub = _audioPlayer.positionStream
        .listen((p) => setState(() => _position = p));
    _durationSub = _audioPlayer.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });
    _currentIndexSub = _audioPlayer.currentIndexStream.listen((i) {
      if (i != null) setState(() => _currentIndex = i);
    });
  }

  @override
  void dispose() {
    _playerStateSub.cancel();
    _positionSub.cancel();
    _durationSub.cancel();
    _currentIndexSub.cancel();
    _audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _position = _audioPlayer.position;
        _duration = _audioPlayer.duration ?? Duration.zero;
      });
    }
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songs[_currentIndex];
    final isPlaying = _audioPlayer.playerState.playing;
    final processingState = _audioPlayer.playerState.processingState;

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
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
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
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20.r,
                    offset: Offset(0, 15.h),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(currentSong['title'] ?? '',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Text(currentSong['artist'] ?? '',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400)),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(_formatTime(_position),
                    style: const TextStyle(color: Colors.grey)),
                Expanded(
                  child: Slider(
                    value: _position.inSeconds
                        .toDouble()
                        .clamp(0.0, _duration.inSeconds.toDouble()),
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                    activeColor: Colors.red,
                  ),
                ),
                Text(_formatTime(_duration),
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: Icon(Icons.skip_previous, size: 35.w),
                    onPressed: _audioPlayer.seekToPrevious),
                processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 60.w,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          isPlaying
                              ? _audioPlayer.pause()
                              : _audioPlayer.play();
                        },
                      ),
                IconButton(
                    icon: Icon(Icons.skip_next, size: 35.w),
                    onPressed: _audioPlayer.seekToNext),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
