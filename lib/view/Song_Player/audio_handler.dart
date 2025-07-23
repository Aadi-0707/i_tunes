// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';

// class MediaState {
//   final MediaItem? mediaItem;
//   final Duration position;

//   MediaState(this.mediaItem, this.position);
// }

// class AudioPlayerHandler extends BaseAudioHandler
//     with QueueHandler, SeekHandler {
//   static final AudioPlayerHandler _instance = AudioPlayerHandler._internal();

//   factory AudioPlayerHandler() => _instance;

//   AudioPlayerHandler._internal() {
//     _init();
//   }

//   final AudioPlayer _audioPlayer = AudioPlayer();
//   AudioPlayer get audioPlayer => _audioPlayer;

//   final List<MediaItem> _mediaItems = [];
//   final _playbackState = BehaviorSubject<PlaybackState>();

//   void _init() {
//     _audioPlayer.playbackEventStream.listen((event) => _updatePlaybackState());

//     _audioPlayer.currentIndexStream.listen((index) {
//       if (index != null && index < _mediaItems.length) {
//         mediaItem.add(_mediaItems[index]);
//       }
//     });

//     //  _audioPlayer.durationStream.listen((duration) {
//     //     final index = _audioPlayer.currentIndex;
//     //     if (index != null &&
//     //         index < _mediaItems.length &&
//     //         duration != null &&
//     //         _mediaItems[index].duration != duration) {
//     //       _mediaItems[index] = _mediaItems[index].copyWith(duration: duration);
//     //       mediaItem.add(_mediaItems[index]);
//     //       queue.add(_mediaItems);
//     //     }
//     //   });
//   }

//   void _updatePlaybackState() {
//     final playing = _audioPlayer.playing;
//     final processingState = _audioPlayer.processingState;
//     final currentIndex = _audioPlayer.currentIndex;

//     _playbackState.add(PlaybackState(
//       controls: [
//         MediaControl.skipToPrevious,
//         if (playing) MediaControl.pause else MediaControl.play,
//         MediaControl.skipToNext,
//       ],
//       androidCompactActionIndices: const [0, 1, 2],
//       processingState: {
//             ProcessingState.idle: AudioProcessingState.idle,
//             ProcessingState.loading: AudioProcessingState.loading,
//             ProcessingState.buffering: AudioProcessingState.buffering,
//             ProcessingState.ready: AudioProcessingState.ready,
//             ProcessingState.completed: AudioProcessingState.completed,
//           }[processingState] ??
//           AudioProcessingState.idle,
//       playing: playing,
//       updatePosition: _audioPlayer.position,
//       bufferedPosition: _audioPlayer.bufferedPosition,
//       speed: _audioPlayer.speed,
//       queueIndex: currentIndex,
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//     ));
//   }

//   @override
//   Future<void> play() => _audioPlayer.play();

//   @override
//   Future<void> pause() => _audioPlayer.pause();

//   @override
//   Future<void> stop() async {
//     await _audioPlayer.stop();
//     await _playbackState.close();
//     return super.stop();
//   }

//   @override
//   Future<void> seek(Duration position) => _audioPlayer.seek(position);

//   @override
//   Future<void> skipToNext() => _audioPlayer.seekToNext();

//   @override
//   Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();

//   @override
//   Future<void> skipToQueueItem(int index) async {
//     if (index >= 0 && index < _mediaItems.length) {
//       await _audioPlayer.seek(Duration.zero, index: index);
//     }
//   }

//   @override
//   BehaviorSubject<PlaybackState> get playbackState => _playbackState;

//   Stream<MediaState> get mediaStateStream =>
//       Rx.combineLatest2<MediaItem?, Duration, MediaState>(
//         mediaItem,
//         _audioPlayer.positionStream,
//         (mediaItem, position) => MediaState(mediaItem, position),
//       );

//   Future<void> initializeAudioSource(
//       List<Map<String, String>> songs, int initialIndex) async {
//     _mediaItems.clear();
//     final audioSources = <AudioSource>[];

//     for (var song in songs) {
//       final mediaItem = MediaItem(
//         id: song['audioUrl'] ?? '',
//         title: song['title'] ?? 'Unknown Title',
//         artist: song['artist'] ?? 'Unknown Artist',
//         artUri: Uri.tryParse(song['imageUrl'] ?? ''),
//         duration: const Duration(seconds: 30), // Hardcoded duration
//       );

//       _mediaItems.add(mediaItem); // FIX: This was missing in your code!

//       audioSources.add(AudioSource.uri(Uri.parse(song['audioUrl']!)));
//     }

//     queue.add(_mediaItems);

//     await _audioPlayer.setAudioSource(
//       ConcatenatingAudioSource(children: audioSources),
//       initialIndex: initialIndex,
//     );

//     mediaItem.add(_mediaItems[initialIndex]);

//     _audioPlayer.setLoopMode(LoopMode.all);
//     _updatePlaybackState();
//   }

//   Future<void> seekTo(Duration position) async {
//     final duration = _audioPlayer.duration;
//     if (duration != null && position <= duration) {
//       await _audioPlayer.seek(position);
//     }
//   }

//   @override
//   Future<void> onTaskRemoved() async {
//     await _audioPlayer.dispose();
//     await _playbackState.close();
//     super.onTaskRemoved();
//   }
// }

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class AudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static final AudioPlayerHandler _instance = AudioPlayerHandler._internal();

  factory AudioPlayerHandler() => _instance;

  AudioPlayerHandler._internal() {
    _init();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;

  final List<MediaItem> _mediaItems = [];
  final _playbackState = BehaviorSubject<PlaybackState>();

  /// ✅ Position Stream Getter (for Mini Player)
  Stream<Duration> get position => _audioPlayer.positionStream;

  void _init() {
    _audioPlayer.playbackEventStream.listen((event) => _updatePlaybackState());

    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < _mediaItems.length) {
        mediaItem.add(_mediaItems[index]);
      }
    });
  }

  void _updatePlaybackState() {
    final playing = _audioPlayer.playing;
    final processingState = _audioPlayer.processingState;
    final currentIndex = _audioPlayer.currentIndex;

    _playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      processingState: {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[processingState] ??
          AudioProcessingState.idle,
      playing: playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: currentIndex,
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
    ));
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    await _playbackState.close();
    return super.stop();
  }

  @override
  Future<void> seek(Duration position) => _audioPlayer.seek(position);

  @override
  Future<void> skipToNext() => _audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < _mediaItems.length) {
      await _audioPlayer.seek(Duration.zero, index: index);
    }
  }

  @override
  BehaviorSubject<PlaybackState> get playbackState => _playbackState;

  /// ✅ Combined stream of media item + current position
  Stream<MediaState> get mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
        mediaItem,
        _audioPlayer.positionStream,
        (mediaItem, position) => MediaState(mediaItem, position),
      );

  /// ✅ Load playlist and prepare audio player
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
        duration: const Duration(seconds: 30), // Example static duration
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

    _audioPlayer.setLoopMode(LoopMode.all);
    _updatePlaybackState();
  }

  /// ✅ Optional external seek
  Future<void> seekTo(Duration position) async {
    final duration = _audioPlayer.duration;
    if (duration != null && position <= duration) {
      await _audioPlayer.seek(position);
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    await _audioPlayer.dispose();
    await _playbackState.close();
    super.onTaskRemoved();
  }
}
