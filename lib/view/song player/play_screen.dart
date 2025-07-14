import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/widget/audio_handler.dart';

class PlayScreen extends StatefulWidget {
  final List<Map<String, String>> songs;
  final int initialIndex;

  const PlayScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
    required AudioPlayerHandler audioHandler,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final _audioHandler = AudioPlayerHandler();

  late final ValueNotifier<int> _currentIndexNotifier =
      ValueNotifier(widget.initialIndex);
  Duration _progress = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool isPlaying = false;
  bool _isUserSeeking = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await _audioHandler.initializeAudioSource(
        widget.songs, widget.initialIndex);
    _setupListeners();
    await _audioHandler.play();
  }

  void _setupListeners() {
    _audioHandler.currentIndexStream.listen((index) {
      if (mounted && index != null && index < widget.songs.length) {
        _currentIndexNotifier.value = index;
      }
    });

    _audioHandler.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() => _totalDuration = duration);
      }
    });

    _audioHandler.positionStream.listen((position) {
      if (mounted && !_isUserSeeking) {
        setState(() => _progress = position);
      }
    });

    _audioHandler.playbackState.listen((state) {
      if (mounted) {
        final playing = state.playing &&
            state.processingState != AudioProcessingState.completed;
        setState(() => isPlaying = playing);
      }
    });
  }

  void _playNext() => _audioHandler.skipToNext();
  void _playPrevious() => _audioHandler.skipToPrevious();
  void _togglePlayPause() =>
      isPlaying ? _audioHandler.pause() : _audioHandler.play();

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
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
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndexNotifier,
      builder: (context, currentIndex, _) {
        final currentSong = widget.songs[currentIndex];

        return Scaffold(
          backgroundColor: Colors.redAccent[50],
          appBar: AppBar(
            backgroundColor: Colors.redAccent[50],
            elevation: 0,
            title: const Text('Playing', style: TextStyle(color: Colors.black)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () {
                _audioHandler.pause(); // ❌ Don't stop, just pause
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.h),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                _buildArtwork(currentSong),
                SizedBox(height: 30.h),
                Text(currentSong['title'] ?? 'Unknown Title',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(currentSong['artist'] ?? 'Unknown Artist',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.w400)),
                SizedBox(height: 20.h),
                _buildSlider(),
                SizedBox(height: 20.h),
                _buildControls(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtwork(Map<String, String> currentSong) {
    final imageUrl = currentSong['imageUrl'] ?? '';

    return Container(
      height: 350,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(340.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 20.r,
            offset: Offset(0, 15.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(340.r),
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultArtwork(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildDefaultArtwork();
                },
              )
            : _buildDefaultArtwork(),
      ),
    );
  }

  Widget _buildDefaultArtwork() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.music_note, size: 100, color: Colors.grey),
    );
  }

  Widget _buildSlider() {
    return Row(
      children: [
        Text(_formatTime(_progress),
            style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Slider(
            value: _totalDuration.inMilliseconds > 0
                ? _progress.inMilliseconds
                    .toDouble()
                    .clamp(0.0, _totalDuration.inMilliseconds.toDouble())
                : 0.0,
            min: 0.0,
            max: _totalDuration.inMilliseconds > 0
                ? _totalDuration.inMilliseconds.toDouble()
                : 1.0,
            onChangeStart: (_) => setState(() => _isUserSeeking = true),
            onChanged: (value) => setState(
                () => _progress = Duration(milliseconds: value.toInt())),
            onChangeEnd: (value) async {
              final newPosition = Duration(milliseconds: value.toInt());
              await _audioHandler.seek(newPosition);
              setState(() {
                _progress = newPosition;
                _isUserSeeking = false;
              });
            },
            activeColor: Colors.red,
            inactiveColor: Colors.grey[300],
          ),
        ),
        Text(_formatTime(_totalDuration),
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            icon: Icon(Icons.skip_previous, size: 35.w),
            onPressed: _playPrevious),
        IconButton(
          icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.red,
              size: 60.w),
          onPressed: _togglePlayPause,
        ),
        IconButton(
            icon: Icon(Icons.skip_next, size: 35.w), onPressed: _playNext),
      ],
    );
  }
}
