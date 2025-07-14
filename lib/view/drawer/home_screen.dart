import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/drawer/feedback_screen.dart';
import 'package:i_tunes/view/song%20player/play_screen.dart';
import 'package:marquee/marquee.dart';
import 'package:i_tunes/view/drawer/playlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_tunes/widget/audio_handler.dart';

class HomeScreen extends StatefulWidget {
  final AudioPlayerHandler audioHandler;

  const HomeScreen({super.key, required this.audioHandler});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<SongModel> songs = [];
  List<SongModel> playlist = [];
  SongModel? selectedSong;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);
    await loadPlaylist();
    await fetchSongs();
    setState(() => isLoading = false);
  }

  Future<void> fetchSongs() async {
    try {
      final response = await Dio().get(
        'https://itunes.apple.com/us/rss/topsongs/limit=20/json',
      );

      if (response.statusCode == 200) {
        final data =
            response.data is String ? jsonDecode(response.data) : response.data;

        final List<dynamic> entries = data['feed']['entry'];

        setState(() {
          songs = entries.map((json) => SongModel.fromJson(json)).toList();
          selectedSong = songs.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching songs: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> savePlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> songList =
        playlist.map((song) => jsonEncode(song.toJson())).toList();
    await prefs.setStringList('playlist', songList);
  }

  Future<void> loadPlaylist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? songList = prefs.getStringList('playlist');
    if (songList != null && songList.isNotEmpty) {
      playlist = songList
          .map((songString) => SongModel.fromJson(jsonDecode(songString)))
          .toList();
    } else {
      playlist = [];
    }
  }

  bool isSongInPlaylist(SongModel song) {
    return playlist.any((s) => s.audioUrl == song.audioUrl);
  }

  void togglePlaylist(SongModel song) async {
    setState(() {
      if (isSongInPlaylist(song)) {
        playlist.removeWhere((s) => s.audioUrl == song.audioUrl);
      } else {
        playlist.add(song);
      }
    });
    await savePlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      drawer: _buildDrawer(),
      body: Padding(
        padding: EdgeInsets.only(top: 60.w),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (selectedSong != null) _buildFirstCard(selectedSong!),
                  SizedBox(height: 20.h),
                  Text('TOP 20 Songs',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp)),
                  SizedBox(height: 5.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        return _buildSecondCard(songs[index], index);
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/music_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListTile(
              title: Text('iTunes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                      color: Colors.white)),
              subtitle: Text('Menu',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp,
                      color: Colors.white)),
            ),
          ),
          _buildDrawerTile(Icons.music_note, 'Home', () {
            Navigator.pop(context);
          }),
          _buildDrawerTile(Icons.queue_music, 'Playlist', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistScreen(
                  playlistSongs: playlist,
                  onPlaylistChanged: (updatedList) {
                    setState(() {
                      playlist = updatedList;
                    });
                    savePlaylist();
                  },
                  audioHandler: widget.audioHandler,
                ),
              ),
            );
          }),
          _buildDrawerTile(Icons.feedback, 'Feedback', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/music_bg.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFirstCard(SongModel song) {
    int songIndex = songs.indexOf(song);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(
          image: AssetImage('assets/images/music_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                Hero(
                  tag: 'albumArt',
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90.r),
                      image: DecorationImage(
                        image: NetworkImage(song.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: SizedBox(
                      height: 25.h,
                      child: Marquee(
                        text: song.title,
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        blankSpace: 80.0,
                        velocity: 40.0,
                        pauseAfterRound: const Duration(seconds: 0),
                        startPadding: 10.0,
                      ),
                    ),
                    subtitle: Text(
                      song.artist,
                      style: const TextStyle(color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 36.h),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayScreen(
                          songs: songs
                              .map((song) => {
                                    'title': song.title,
                                    'artist': song.artist,
                                    'imageUrl': song.imageUrl,
                                    'audioUrl': song.audioUrl,
                                  })
                              .toList(),
                          initialIndex: songIndex,
                          audioHandler: widget.audioHandler,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondCard(SongModel song, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
            title:
                Text(song.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(song.artist,
                style: const TextStyle(color: Colors.white70)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isSongInPlaylist(song)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () {
                    togglePlaylist(song);
                  },
                ),
                const Icon(Icons.play_arrow, color: Colors.white, size: 26),
              ],
            ),
            onTap: () {
              setState(() {
                selectedSong = song;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayScreen(
                    songs: songs
                        .map((song) => {
                              'title': song.title,
                              'artist': song.artist,
                              'imageUrl': song.imageUrl,
                              'audioUrl': song.audioUrl,
                            })
                        .toList(),
                    initialIndex: index,
                    audioHandler: widget.audioHandler,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
