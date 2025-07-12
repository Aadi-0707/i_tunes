// import 'dart:async';
// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class AudioPlayerHandler extends BaseAudioHandler
//     with QueueHandler, SeekHandler {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final List<MediaItem> _queue = [];
//   int _queueIndex = -1;

//   bool get hasNext => _queueIndex + 1 < _queue.length;
//   bool get hasPrevious => _queueIndex > 0;

//   AudioPlayerHandler() {
//     _init();

//     // Initialize with idle state
//     playbackState.add(PlaybackState(
//       controls: [],
//       processingState: AudioProcessingState.idle,
//       playing: false,
//       updatePosition: Duration.zero,
//       bufferedPosition: Duration.zero,
//       speed: 1.0,
//     ));
//   }

//   Future<void> _init() async {
//     // Listen to player state changes
//     _audioPlayer.playerStateStream.listen((state) {
//       final isPlaying = state.playing;
//       final processingState = _getProcessingState(state);

//       _updatePlaybackState(
//         processingState: processingState,
//         playing: isPlaying,
//       );
//     });

//     // Listen to position changes more frequently
//     _audioPlayer.positionStream.listen((position) {
//       _updatePlaybackState(
//         position: position,
//       );
//     });

//     // Listen to buffered position changes
//     _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
//       _updatePlaybackState(
//         bufferedPosition: bufferedPosition,
//       );
//     });

//     // Listen for the end of the audio
//     _audioPlayer.processingStateStream.listen((processingState) {
//       if (processingState == ProcessingState.completed) {
//         _handleAudioCompleted();
//       }
//     });
//   }

//   void _updatePlaybackState({
//     AudioProcessingState? processingState,
//     bool? playing,
//     Duration? position,
//     Duration? bufferedPosition,
//   }) {
//     final currentState = playbackState.value;

//     playbackState.add(PlaybackState(
//       controls: _getControls(),
//       systemActions: const {
//         MediaAction.seek,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       },
//       androidCompactActionIndices: const [0, 1, 3],
//       processingState: processingState ?? currentState.processingState,
//       playing: playing ?? currentState.playing,
//       updatePosition: position ?? currentState.updatePosition,
//       bufferedPosition: bufferedPosition ?? currentState.bufferedPosition,
//       speed: _audioPlayer.speed,
//       queueIndex: _queueIndex,
//     ));
//   }

//   AudioProcessingState _getProcessingState(PlayerState state) {
//     switch (state.processingState) {
//       case ProcessingState.idle:
//         return AudioProcessingState.idle;
//       case ProcessingState.loading:
//         return AudioProcessingState.loading;
//       case ProcessingState.buffering:
//         return AudioProcessingState.buffering;
//       case ProcessingState.ready:
//         return AudioProcessingState.ready;
//       case ProcessingState.completed:
//         return AudioProcessingState.completed;
//     }
//   }

//   List<MediaControl> _getControls() {
//     return [
//       MediaControl.skipToPrevious,
//       if (_audioPlayer.playerState.playing)
//         MediaControl.pause
//       else
//         MediaControl.play,
//       // MediaControl.stop,
//       MediaControl.skipToNext,
//     ];
//   }

//   @override
//   Future<void> addQueueItems(List<MediaItem> mediaItems) async {
//     _queue.clear();
//     _queue.addAll(mediaItems);
//     queue.add(_queue);

//     // Start with the first item
//     if (_queue.isNotEmpty) {
//       await skipToQueueItem(0);
//     }
//   }

//   @override
//   Future<void> play() async {
//     await _audioPlayer.play();
//   }

//   @override
//   Future<void> pause() async {
//     await _audioPlayer.pause();
//   }

//   @override
//   Future<void> stop() async {
//     await _audioPlayer.stop();
//     await _audioPlayer.dispose();
//     playbackState.add(PlaybackState(
//       controls: [],
//       processingState: AudioProcessingState.idle,
//       playing: false,
//       updatePosition: Duration.zero,
//       bufferedPosition: Duration.zero,
//       speed: 1.0,
//     ));
//   }

//   @override
//   Future<void> seek(Duration position) async {
//     await _audioPlayer.seek(position);
//   }

//   @override
//   Future<void> skipToNext() async {
//     if (hasNext) {
//       await skipToQueueItem(_queueIndex + 1);
//     }
//   }

//   @override
//   Future<void> skipToPrevious() async {
//     if (hasPrevious) {
//       await skipToQueueItem(_queueIndex - 1);
//     }
//   }

//   @override
//   Future<void> skipToQueueItem(int index) async {
//     if (index < 0 || index >= _queue.length) return;

//     final wasPlaying = _audioPlayer.playerState.playing;

//     _queueIndex = index;
//     final mediaItem = _queue[index];

//     // Update the current media item
//     this.mediaItem.add(mediaItem);

//     // Load the new audio source
//     try {
//       await _audioPlayer
//           .setAudioSource(AudioSource.uri(Uri.parse(mediaItem.id)));

//       // If it was playing before, continue playing
//       if (wasPlaying) {
//         await _audioPlayer.play();
//       }
//     } catch (e) {
//       print('Error loading audio source: $e');
//     }
//   }

//   @override
//   Future<void> fastForward() async {
//     await _seekRelative(const Duration(seconds: 10));
//   }

//   @override
//   Future<void> rewind() async {
//     await _seekRelative(const Duration(seconds: -10));
//   }

//   Future<void> _seekRelative(Duration offset) async {
//     var newPosition = _audioPlayer.position + offset;
//     if (newPosition < Duration.zero) {
//       newPosition = Duration.zero;
//     }
//     final duration = _audioPlayer.duration;
//     if (duration != null && newPosition > duration) {
//       newPosition = duration;
//     }
//     await _audioPlayer.seek(newPosition);
//   }

//   void _handleAudioCompleted() {
//     if (hasNext) {
//       skipToNext();
//     } else {
//       stop();
//     }
//   }

//   @override
//   Future<void> onTaskRemoved() async {
//     await stop();
//   }
// }
