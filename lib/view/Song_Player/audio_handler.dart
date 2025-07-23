import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Stream<Duration> get position => _audioPlayer.positionStream;

  Future<void> _init() async {
    _audioPlayer.playbackEventStream.listen((event) => _updatePlaybackState());

    _audioPlayer.currentIndexStream.listen((index) async {
      if (index != null && index < _mediaItems.length) {
        mediaItem.add(_mediaItems[index]);
        await _saveLastPlayed(mediaItem.value, _audioPlayer.position);
      }
    });

    await _restoreLastPlayed();
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

  Stream<MediaState> get mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
        mediaItem,
        _audioPlayer.positionStream,
        (mediaItem, position) => MediaState(mediaItem, position),
      );

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
        duration: const Duration(seconds: 30),
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

  Future<void> _saveLastPlayed(MediaItem? item, Duration position) async {
    if (item == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'last_media',
        jsonEncode({
          'id': item.id,
          'title': item.title,
          'artist': item.artist,
          'imageUrl': item.artUri?.toString(),
          'position': position.inMilliseconds,
        }));
  }

  Future<void> _restoreLastPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('last_media');
    if (saved != null) {
      final data = jsonDecode(saved);
      final media = MediaItem(
        id: data['id'] ?? '',
        title: data['title'] ?? 'Unknown',
        artist: data['artist'] ?? 'Unknown',
        artUri: Uri.tryParse(data['imageUrl'] ?? ''),
        duration: const Duration(seconds: 30),
      );
      final lastPos = Duration(milliseconds: data['position'] ?? 0);
      _mediaItems.clear();
      _mediaItems.add(media);
      mediaItem.add(media);

      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(media.id)));
      await _audioPlayer.seek(lastPos);
      await _audioPlayer.pause();
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    await _audioPlayer.dispose();
    await _playbackState.close();
    super.onTaskRemoved();
  }
}
