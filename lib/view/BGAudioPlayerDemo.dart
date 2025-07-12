// import 'dart:math';
// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
// import 'package:i_tunes/view/AudioPlayerTask.dart';
// import 'package:rxdart/rxdart.dart';

// class BGAudioPlayerScreen extends StatefulWidget {
//   const BGAudioPlayerScreen({super.key});

//   @override
//   BGAudioPlayerScreenState createState() => BGAudioPlayerScreenState();
// }

// class BGAudioPlayerScreenState extends State<BGAudioPlayerScreen> {
//   AudioHandler? _audioHandler;
//   final BehaviorSubject<double?> _dragPositionSubject =
//       BehaviorSubject.seeded(null);
//   bool _loading = false;

//   final _queue = <MediaItem>[
//     MediaItem(
//       id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
//       album: "Science Friday",
//       title: "A Salute To Head-Scratching Science",
//       artist: "Science Friday and WNYC Studios",
//       duration: Duration(milliseconds: 5739820),
//       artUri: Uri.parse(
//           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
//     ),
//     MediaItem(
//       id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
//       album: "Science Friday",
//       title: "From Cat Rheology To Operatic Incompetence",
//       artist: "Science Friday and WNYC Studios",
//       duration: Duration(milliseconds: 2856950),
//       artUri: Uri.parse(
//           "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loading = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Player'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20.0),
//         color: Colors.white,
//         child: StreamBuilder<AudioState?>(
//           stream: _audioStateStream,
//           builder: (context, snapshot) {
//             final audioState = snapshot.data;
//             final queue = audioState?.queue;
//             final mediaItem = audioState?.mediaItem;
//             final playbackState = audioState?.playbackState;
//             final processingState =
//                 playbackState?.processingState ?? AudioProcessingState.idle;
//             final playing = playbackState?.playing ?? false;

//             return Container(
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   if (_audioHandler == null ||
//                       processingState == AudioProcessingState.idle) ...[
//                     _startAudioPlayerBtn(),
//                   ] else ...[
//                     positionIndicator(mediaItem, playbackState),
//                     SizedBox(height: 20),
//                     if (mediaItem?.title != null) Text(mediaItem!.title),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.skip_previous),
//                           iconSize: 64,
//                           onPressed: () {
//                             if (queue != null &&
//                                 mediaItem != null &&
//                                 mediaItem != queue.first) {
//                               _audioHandler?.skipToPrevious();
//                             }
//                           },
//                         ),
//                         !playing
//                             ? IconButton(
//                                 icon: Icon(Icons.play_arrow),
//                                 iconSize: 64.0,
//                                 onPressed: () => _audioHandler?.play(),
//                               )
//                             : IconButton(
//                                 icon: Icon(Icons.pause),
//                                 iconSize: 64.0,
//                                 onPressed: () => _audioHandler?.pause(),
//                               ),
//                         IconButton(
//                           icon: Icon(Icons.skip_next),
//                           iconSize: 64,
//                           onPressed: () {
//                             if (queue != null &&
//                                 mediaItem != null &&
//                                 mediaItem != queue.last) {
//                               _audioHandler?.skipToNext();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     IconButton(
//                       icon: Icon(Icons.stop),
//                       iconSize: 64.0,
//                       onPressed: () => _audioHandler?.stop(),
//                     ),
//                   ]
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _startAudioPlayerBtn() {
//     return ElevatedButton(
//       child: Text(_loading ? "Loading..." : 'Start Audio Player'),
//       onPressed: () async {
//         setState(() {
//           _loading = true;
//         });

//         try {
//           _audioHandler = await AudioService.init(
//             builder: () => AudioPlayerHandler(),
//             config: AudioServiceConfig(
//               androidNotificationChannelId: 'com.example.app.channel.audio',
//               androidNotificationChannelName: 'Audio Player',
//               androidNotificationOngoing: true,
//               androidStopForegroundOnPause: true,
//             ),
//           );

//           // Add queue to handler
//           await _audioHandler?.addQueueItems(_queue);

//           setState(() {
//             _loading = false;
//           });
//         } catch (e) {
//           print('Error initializing audio service: $e');
//           setState(() {
//             _loading = false;
//           });
//         }
//       },
//     );
//   }

//   Widget positionIndicator(MediaItem? mediaItem, PlaybackState? state) {
//     double? seekPos;

//     // Get current position and duration
//     double? position = state?.position.inMilliseconds.toDouble();
//     double? duration = mediaItem?.duration?.inMilliseconds.toDouble();

//     if (duration == null || position == null) {
//       return Container();
//     }

//     return StreamBuilder<double?>(
//       stream: _dragPositionSubject.stream,
//       builder: (context, snapshot) {
//         double? dragPosition = snapshot.data;

//         return Column(
//           children: [
//             Slider(
//               min: 0.0,
//               max: duration,
//               value: dragPosition ?? max(0.0, min(position, duration)),
//               onChanged: (value) {
//                 _dragPositionSubject.add(value);
//               },
//               onChangeEnd: (value) {
//                 _audioHandler?.seek(Duration(milliseconds: value.toInt()));
//                 _dragPositionSubject.add(null);
//               },
//             ),
//             Text(
//                 "${Duration(milliseconds: (dragPosition ?? position).toInt())}"),
//           ],
//         );
//       },
//     );
//   }

//   Stream<AudioState?> get _audioStateStream {
//     if (_audioHandler == null) {
//       return Stream.value(null);
//     }

//     return Rx.combineLatest3<List<MediaItem>, MediaItem?, PlaybackState,
//         AudioState>(
//       _audioHandler!.queue,
//       _audioHandler!.mediaItem,
//       _audioHandler!.playbackState,
//       (queue, mediaItem, playbackState) => AudioState(
//         queue,
//         mediaItem,
//         playbackState,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _dragPositionSubject.close();
//     super.dispose();
//   }
// }

// class AudioState {
//   final List<MediaItem> queue;
//   final MediaItem? mediaItem;
//   final PlaybackState playbackState;

//   AudioState(this.queue, this.mediaItem, this.playbackState);
// }
