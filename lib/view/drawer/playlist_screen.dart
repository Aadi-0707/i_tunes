import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/view/song%20player/play_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key, required List<SongModel> playlistSongs});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<SongModel> playlistSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlaylist();
  }

  Future<void> loadPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    final playlistJson = prefs.getString('playlist') ?? '[]';
    final List<dynamic> decoded = jsonDecode(playlistJson);
    setState(() {
      playlistSongs = decoded.map((e) => SongModel.fromJson(e)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent[50],
        elevation: 0,
        title: const Text('My Playlist', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : playlistSongs.isEmpty
              ? const Center(child: Text("Your playlist is empty"))
              : ListView.builder(
                  itemCount: playlistSongs.length,
                  itemBuilder: (context, index) {
                    final song = playlistSongs[index];
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/music_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(song.imageUrl),
                            ),
                            title: Text(song.title,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(song.artist,
                                style: const TextStyle(color: Colors.white70)),
                            trailing: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 26),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayScreen(
                                    songs: playlistSongs
                                        .map((song) => {
                                              'title': song.title,
                                              'artist': song.artist,
                                              'imageUrl': song.imageUrl,
                                              'audioUrl': song.audioUrl,
                                            })
                                        .toList(),
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
