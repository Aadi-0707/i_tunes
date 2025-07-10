// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
//   final _player = AudioPlayer();

//   // Getter to access the player from outside
//   AudioPlayer get player => _player;

//   MyAudioHandler() {
//     _player.playerStateStream.listen((state) {
//       playbackState.add(playbackState.value.copyWith(
//         playing: state.playing,
//         processingState: {
//           ProcessingState.idle: AudioProcessingState.idle,
//           ProcessingState.loading: AudioProcessingState.loading,
//           ProcessingState.buffering: AudioProcessingState.buffering,
//           ProcessingState.ready: AudioProcessingState.ready,
//           ProcessingState.completed: AudioProcessingState.completed,
//         }[state.processingState]!,
//         controls: [
//           MediaControl.skipToPrevious,
//           if (state.playing) MediaControl.pause else MediaControl.play,
//           MediaControl.skipToNext,
//         ],
//         systemActions: const {
//           MediaAction.seek,
//           MediaAction.seekForward,
//           MediaAction.seekBackward,
//         },
//         androidCompactActionIndices: const [0, 1, 2],
//       ));
//     });

//     _player.currentIndexStream.listen((index) {
//       if (index != null && index < queue.value.length) {
//         mediaItem.add(queue.value[index]);
//       }
//     });

//     _player.positionStream.listen((position) {
//       playbackState.add(playbackState.value.copyWith(
//         updatePosition: position,
//       ));
//     });

//     _player.durationStream.listen((duration) {
//       if (duration != null) {
//         playbackState.add(playbackState.value.copyWith(
//           bufferedPosition: duration,
//         ));
//       }
//     });
//   }

//   Future<void> loadQueue(List<MediaItem> items, {int startIndex = 0}) async {
//     queue.add(items);
//     final sources = items
//         .map((item) => AudioSource.uri(
//               Uri.parse(item.id),
//               tag: item,
//             ))
//         .toList();

//     await _player.setAudioSource(
//       ConcatenatingAudioSource(children: sources),
//       initialIndex: startIndex,
//     );

//     await _player.setLoopMode(LoopMode.all);

//     // Update the current media item
//     if (startIndex < items.length) {
//       mediaItem.add(items[startIndex]);
//     }
//   }

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> stop() async {
//     await _player.pause();
//   }

//   @override
//   Future<void> seek(Duration position) async {
//     // Update the playback state immediately for responsive UI
//     playbackState.add(playbackState.value.copyWith(
//       updatePosition: position,
//     ));

//     // Perform the actual seek
//     await _player.seek(position);
//   }

//   @override
//   Future<void> skipToNext() => _player.seekToNext();

//   @override
//   Future<void> skipToPrevious() => _player.seekToPrevious();

//   @override
//   Future<void> onTaskRemoved() async {
//     // Keep the service running when task is removed
//   }

//   @override
//   Future<void> onNotificationDeleted() async {
//     await _player.pause();
//   }

// }

// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class MyAudioHandler extends BaseAudioHandler with SeekHandler, QueueHandler {
//   final _player = AudioPlayer();

//   MyAudioHandler() {
//     _player.playerStateStream.listen((state) {
//       playbackState.add(playbackState.value.copyWith(
//         playing: state.playing,
//         controls: [
//           MediaControl.skipToPrevious,
//           if (state.playing) MediaControl.pause else MediaControl.play,
//           MediaControl.skipToNext,
//         ],
//         processingState: {
//           ProcessingState.idle: AudioProcessingState.idle,
//           ProcessingState.loading: AudioProcessingState.loading,
//           ProcessingState.buffering: AudioProcessingState.buffering,
//           ProcessingState.ready: AudioProcessingState.ready,
//           ProcessingState.completed: AudioProcessingState.completed,
//         }[state.processingState]!,
//         updatePosition: _player.position,

//       ));
//     });

//     _player.currentIndexStream.listen((index) {
//       if (index != null && index < queue.value.length) {
//         mediaItem.add(queue.value[index]);
//       }
//     });

//     _player.positionStream.listen((pos) {
//       playbackState.add(playbackState.value.copyWith(updatePosition: pos));
//     });
//   }

//   Future<void> loadQueue(List<MediaItem> items, {int startIndex = 0}) async {
//     queue.add(items);
//     final sources = items
//         .map((item) => AudioSource.uri(Uri.parse(item.id), tag: item))
//         .toList();

//     await _player.setAudioSource(
//       ConcatenatingAudioSource(children: sources),
//       initialIndex: startIndex,
//     );
//     await _player.setLoopMode(LoopMode.all);
//     mediaItem.add(items[startIndex]);
//   }

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> stop() async {
//     await _player.stop();
//     return super.stop();
//   }

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);

//   @override
//   Future<void> skipToNext() => _player.seekToNext();

//   @override
//   Future<void> skipToPrevious() => _player.seekToPrevious();
// }
