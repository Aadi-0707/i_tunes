import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  static final AudioPlayerHandler _instance = AudioPlayerHandler._internal();
  factory AudioPlayerHandler() => _instance;
  AudioPlayerHandler._internal();

  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;
  int _currentIndex = 0;
  List<Map<String, String>> _songs = [];

  @override
  Future<void> initializeAudioSource(
      List<Map<String, String>> songs, int initialIndex) async {
    _audioPlayer = AudioPlayer();
    _currentIndex = initialIndex;
    _songs = songs;

    // Create playlist
    _playlist = ConcatenatingAudioSource(
      children: songs.map((song) {
        return AudioSource.uri(
          Uri.parse(song['audioUrl'] ?? ''),
        );
      }).toList(),
    );

    // Set up listeners
    _audioPlayer.playbackEventStream.listen(_broadcastState);
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState != null) {
        final currentIndex = sequenceState.currentIndex ?? 0;
        if (currentIndex < songs.length) {
          _currentIndex = currentIndex;
          final currentSong = songs[currentIndex];
          mediaItem.add(MediaItem(
            id: currentSong['audioUrl']!,
            title: currentSong['title'] ?? 'Unknown',
            artist: currentSong['artist'] ?? 'Unknown',
            artUri: Uri.tryParse(currentSong['imageUrl'] ?? ''),
          ));
        }
      }
    });

    // Initialize audio source
    await _audioPlayer.setAudioSource(_playlist, initialIndex: initialIndex);
    await _audioPlayer.setLoopMode(LoopMode.all);

    // Update queue
    queue.add(songs
        .map((song) => MediaItem(
              id: song['audioUrl']!,
              title: song['title'] ?? 'Unknown',
              artist: song['artist'] ?? 'Unknown',
              artUri: Uri.tryParse(song['imageUrl'] ?? ''),
            ))
        .toList());

    // Set initial media item
    if (songs.isNotEmpty) {
      final initialSong = songs[initialIndex];
      mediaItem.add(MediaItem(
        id: initialSong['audioUrl']!,
        title: initialSong['title'] ?? 'Unknown',
        artist: initialSong['artist'] ?? 'Unknown',
        artUri: Uri.tryParse(initialSong['imageUrl'] ?? ''),
      ));
    }
  }

  @override
  Future<void> play() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    await _audioPlayer.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await _audioPlayer.seekToPrevious();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < queue.value.length) {
      await _audioPlayer.seek(Duration.zero, index: index);
    }
  }

  void _broadcastState(PlaybackEvent event) {
    final playing = _audioPlayer.playing;
    final queueIndex = event.currentIndex ?? 0;

    // Update current media item when track changes
    if (queueIndex < _songs.length && queueIndex != _currentIndex) {
      _currentIndex = queueIndex;
      final currentSong = _songs[queueIndex];
      mediaItem.add(MediaItem(
        id: currentSong['audioUrl']!,
        title: currentSong['title'] ?? 'Unknown',
        artist: currentSong['artist'] ?? 'Unknown',
        artUri: Uri.tryParse(currentSong['imageUrl'] ?? ''),
      ));
    }

    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2], // Show all three buttons
      processingState: const {
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
      queueIndex: queueIndex,
    ));
  }

  // Getter methods to access player state from UI
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<int?> get currentIndexStream => _audioPlayer.currentIndexStream;

  Duration get position => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;
  bool get playing => _audioPlayer.playing;
}
