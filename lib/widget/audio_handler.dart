import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static final AudioPlayerHandler _instance = AudioPlayerHandler._internal();
  factory AudioPlayerHandler() => _instance;
  AudioPlayerHandler._internal() {
    _init();
  }

  final _audioPlayer = AudioPlayer();
  final List<MediaItem> _mediaItems = [];

  // Create BehaviorSubject for playbackState
  final _playbackState = BehaviorSubject<PlaybackState>();

  void _init() {
    // Initialize playback state stream
    _audioPlayer.playbackEventStream.listen((event) {
      final playing = _audioPlayer.playing;
      _playbackState.add(PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 3],
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_audioPlayer.processingState]!,
        playing: playing,
        updatePosition: _audioPlayer.position,
        bufferedPosition: _audioPlayer.bufferedPosition,
        speed: _audioPlayer.speed,
        queueIndex: _audioPlayer.currentIndex,
      ));
    });
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() => _audioPlayer.stop();

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> skipToNext() => _audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();

  @override
  BehaviorSubject<PlaybackState> get playbackState => _playbackState;

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<int?> get currentIndexStream => _audioPlayer.currentIndexStream;

  Future<void> initializeAudioSource(
      List<Map<String, String>> songs, int initialIndex) async {
    _mediaItems.clear();
    final audioSources = <AudioSource>[];

    for (var song in songs) {
      final mediaItem = MediaItem(
        id: song['audioUrl'] ?? '',
        title: song['title'] ?? 'Unknown Title',
        artist: song['artist'] ?? 'Unknown Artist',
        artUri: Uri.tryParse(song['imageUrl'] ?? ''),
      );
      _mediaItems.add(mediaItem);
      audioSources.add(AudioSource.uri(Uri.parse(song['audioUrl']!)));
    }

    queue.add(_mediaItems);

    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: initialIndex,
    );

    mediaItem.add(_mediaItems[initialIndex]);

    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < _mediaItems.length) {
        mediaItem.add(_mediaItems[index]);
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      final index = _audioPlayer.currentIndex;
      if (duration != null && index != null && index < _mediaItems.length) {
        final updatedItem = _mediaItems[index].copyWith(duration: duration);
        _mediaItems[index] = updatedItem;
        mediaItem.add(updatedItem);
        queue.add(_mediaItems);
      }
    });
  }

  @override
  Future<void> onTaskRemoved() async {
    await _playbackState.close();
    super.onTaskRemoved();
  }
}
