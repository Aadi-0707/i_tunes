import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';

class PlayScreen extends StatefulWidget {
  final List<Map<String, String>> songs;
  final int initialIndex;
  final AudioPlayerHandler audioHandler;
  final Function(Map<String, String> currentSong, bool isPlaying) onMinimize;
  final bool isFromMiniPlayer;

  const PlayScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
    required this.audioHandler,
    required this.onMinimize,
    this.isFromMiniPlayer = false,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  late final AudioPlayerHandler _audioHandler;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _audioHandler = widget.audioHandler;
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    if (!widget.isFromMiniPlayer) {
      _initializeAudio();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _initializeAudio() async {
    await _audioHandler.initializeAudioSource(
        widget.songs, widget.initialIndex);
    await _audioHandler.play();
  }

  void _playNext() => _audioHandler.skipToNext();
  void _playPrevious() => _audioHandler.skipToPrevious();
  void _togglePlayPause(bool isPlaying) =>
      isPlaying ? _audioHandler.pause() : _audioHandler.play();

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  String generateHeroTag(MediaItem? mediaItem) {
    if (mediaItem == null) return 'unknown_unknown_';
    final title = mediaItem.title;
    final artist = mediaItem.artist ?? 'unknown';
    final imageUrl = mediaItem.artUri?.toString() ?? '';
    return '${title}_${artist}_$imageUrl'.replaceAll(' ', '_');
  }

  Map<String, String> mediaItemToMap(MediaItem mediaItem) {
    return {
      'title': mediaItem.title,
      'artist': mediaItem.artist ?? 'Unknown Artist',
      'imageUrl': mediaItem.artUri?.toString() ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaState>(
      stream: _audioHandler.mediaStateStream,
      builder: (context, snapshot) {
        final mediaState = snapshot.data;
        final mediaItem = mediaState?.mediaItem;
        final position = mediaState?.position ?? Duration.zero;
        final duration = mediaItem?.duration ?? const Duration(seconds: 30);

        return StreamBuilder<bool>(
          stream: _audioHandler.playbackState.map((state) => state.playing),
          builder: (context, playingSnapshot) {
            final isPlaying = playingSnapshot.data ?? false;
            final currentSong = mediaItem != null
                ? mediaItemToMap(mediaItem)
                : widget.songs.isNotEmpty
                    ? widget.songs[widget.initialIndex]
                    : {'title': 'Unknown', 'artist': 'Unknown', 'imageUrl': ''};

            return Scaffold(
              backgroundColor: Colors.redAccent[50],
              appBar: AppBar(
                backgroundColor: Colors.redAccent[50],
                elevation: 0,
                title: const Text('Playing',
                    style: TextStyle(color: Colors.black)),
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 35, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.h),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),
                    Hero(
                      tag: generateHeroTag(mediaItem),
                      child: _buildArtwork(currentSong, isPlaying),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      currentSong['title'] ?? 'Unknown Title',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      currentSong['artist'] ?? 'Unknown Artist',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20.h),
                    _buildSlider(position, duration),
                    SizedBox(height: 20.h),
                    _buildControls(isPlaying),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildArtwork(Map<String, String> currentSong, bool isPlaying) {
    final imageUrl = currentSong['imageUrl'] ?? '';

    if (isPlaying) {
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }

    return AnimatedBuilder(
      animation: _rotationController,
      builder: (_, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * 3.1415926,
          child: child,
        );
      },
      child: Container(
        height: 350,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(340.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              blurRadius: 20.r,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(340.r),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildDefaultArtwork(),
                )
              : _buildDefaultArtwork(),
        ),
      ),
    );
  }

  Widget _buildDefaultArtwork() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.music_note, size: 100, color: Colors.grey),
    );
  }

  Widget _buildSlider(Duration position, Duration duration) {
    return Row(
      children: [
        Text(_formatTime(position), style: const TextStyle(color: Colors.grey)),
        Expanded(
          child: Slider(
            value: position.inMilliseconds
                .clamp(0, duration.inMilliseconds)
                .toDouble(),
            min: 0.0,
            max: duration.inMilliseconds.toDouble(),
            activeColor: Colors.red,
            inactiveColor: Colors.grey[300],
            onChanged: (double value) {
              _audioHandler.seek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        Text(_formatTime(duration), style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildControls(bool isPlaying) {
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
          onPressed: () => _togglePlayPause(isPlaying),
        ),
        IconButton(
            icon: Icon(Icons.skip_next, size: 35.w), onPressed: _playNext),
      ],
    );
  }
}
