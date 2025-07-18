import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:i_tunes/view/feedback_screen.dart';
import 'package:i_tunes/view/home_screen.dart';
import 'package:i_tunes/view/local_song.dart';
import 'package:i_tunes/view/playlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      const LocalSongScreen(),
      const FeedbackScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
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
}
