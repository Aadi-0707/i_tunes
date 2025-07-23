import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:i_tunes/view/Song_Player/play_screen.dart';
import 'package:i_tunes/view/feedback_screen.dart';
import 'package:i_tunes/view/home_screen.dart';
import 'package:i_tunes/view/local_song.dart';
import 'package:i_tunes/view/playlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audio_service/audio_service.dart';

class BottomBar extends StatefulWidget {
  final AudioPlayerHandler audioHandler;
  const BottomBar({super.key, required this.audioHandler});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  List<SongModel> _playlist = [];

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? songList = prefs.getStringList('playlist');
    if (songList != null && songList.isNotEmpty) {
      setState(() {
        _playlist = songList
            .map(
                (songString) => SongModel.fromLocalJson(jsonDecode(songString)))
            .toList();
      });
    }
  }

  Future<void> _updatePlaylist(List<SongModel> newList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        newList.map((song) => jsonEncode(song.toJson())).toList();
    await prefs.setStringList('playlist', jsonList);

    setState(() {
      _playlist = newList;
    });
  }

  // Remove the old _updateMiniPlayer method as we'll use streams instead

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
    final screens = [
      HomeScreen(
        audioHandler: widget.audioHandler,
        playlist: _playlist,
        onPlaylistChanged: _updatePlaylist,
        onMinimize: (song, isPlaying) {}, // No longer needed
      ),
      PlaylistScreen(
        playlistSongs: _playlist,
        onPlaylistChanged: _updatePlaylist,
        audioHandler: widget.audioHandler,
        onMinimize: (song, isPlaying) {}, // No longer needed
      ),
      const LocalSongScreen(),
      const FeedbackScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(index: _currentIndex, children: screens),
          ),
          _buildMiniPlayer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: const Color.fromRGBO(175, 25, 14, 1),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.redAccent,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Songs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.queue_music), label: 'Playlist'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Local'),
          BottomNavigationBarItem(
              icon: Icon(Icons.feedback), label: 'Feedback'),
        ],
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return StreamBuilder<MediaState>(
      stream: widget.audioHandler.mediaStateStream,
      builder: (context, snapshot) {
        final mediaState = snapshot.data;
        final mediaItem = mediaState?.mediaItem;

        return StreamBuilder<bool>(
          stream:
              widget.audioHandler.playbackState.map((state) => state.playing),
          builder: (context, playingSnapshot) {
            final isPlaying = playingSnapshot.data ?? false;

            // Don't show mini player if no media is loaded
            if (mediaItem == null) {
              return const SizedBox.shrink();
            }

            final currentSong = mediaItemToMap(mediaItem);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayScreen(
                      songs: [currentSong],
                      initialIndex: 0,
                      audioHandler: widget.audioHandler,
                      onMinimize: (song, playing) {}, // No longer needed
                      isFromMiniPlayer: true,
                    ),
                  ),
                );
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Hero(
                      tag: generateHeroTag(mediaItem),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: mediaItem.artUri != null
                            ? Image.network(
                                mediaItem.artUri.toString(),
                                height: 30.h,
                                width: 30.w,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.music_note, size: 40),
                              )
                            : const Icon(Icons.music_note, size: 40),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mediaItem.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            mediaItem.artist ?? 'Unknown Artist',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 22.w,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          widget.audioHandler.pause();
                        } else {
                          widget.audioHandler.play();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
