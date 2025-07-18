import 'package:flutter/material.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:i_tunes/view/feedback_screen.dart';
import 'package:i_tunes/view/home_screen.dart';
import 'package:i_tunes/view/local_song.dart';
import 'package:i_tunes/view/playlist_screen.dart';

class BottomBar extends StatefulWidget {
  final AudioPlayerHandler audioHandler;

  const BottomBar({super.key, required this.audioHandler});

  @override
  State<BottomBar> createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<BottomBar> {
  int _currentIndex = 0;
  List<SongModel> _playlist = [];

  void _updatePlaylist(List<SongModel> newList) {
    setState(() {
      _playlist = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        audioHandler: widget.audioHandler,
        playlist: _playlist,
        onPlaylistChanged: _updatePlaylist,
      ),
      PlaylistScreen(
        playlistSongs: _playlist,
        onPlaylistChanged: _updatePlaylist,
        audioHandler: widget.audioHandler,
      ),
      LocalSongScreen(),
      FeedbackScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.redAccent[50],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music),
            label: 'Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Local',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}
