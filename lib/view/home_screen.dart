import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:i_tunes/view/Song_Player/play_screen.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final AudioPlayerHandler audioHandler;
  final List<SongModel> playlist;
  final Function(List<SongModel>) onPlaylistChanged;

  const HomeScreen({
    super.key,
    required this.audioHandler,
    required this.playlist,
    required this.onPlaylistChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<SongModel> songs = [];
  SongModel? selectedSong;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() => isLoading = true);
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

        songs = entries.map((json) => SongModel.fromJson(json)).toList();

        for (var song in songs) {
          song.isBookmarked =
              widget.playlist.any((p) => p.audioUrl == song.audioUrl);
        }

        selectedSong = songs.isNotEmpty ? songs.first : null;
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

  void togglePlaylist(SongModel song) async {
    List<SongModel> updatedList = List.from(widget.playlist);

    bool isInPlaylist = updatedList.any((s) => s.audioUrl == song.audioUrl);

    if (isInPlaylist) {
      // Remove from playlist
      updatedList.removeWhere((s) => s.audioUrl == song.audioUrl);
      song.isBookmarked = false;
      _showSnackBar('Removed from Playlist', Colors.red);
    } else {
      // Add to playlist
      updatedList.add(song);
      song.isBookmarked = true;
      _showSnackBar('Added to Playlist', Colors.green);
    }

    widget.onPlaylistChanged(updatedList);
    await savePlaylist(updatedList);

    setState(() {});
  }

  Future<void> savePlaylist(List<SongModel> playlist) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> songList =
        playlist.map((song) => jsonEncode(song.toJson())).toList();
    await prefs.setStringList('playlist', songList);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 1),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
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
                        return _buildSongCard(songs[index], index);
                      },
                    ),
                  )
                ],
              ),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 36.h),
                  onPressed: () => _navigateToPlayScreen(songIndex),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongCard(SongModel song, int index) {
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
            leading: CircleAvatar(backgroundImage: NetworkImage(song.imageUrl)),
            title: Text(song.title,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(song.artist,
                style: const TextStyle(color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    song.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () => togglePlaylist(song),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow,
                      color: Colors.white, size: 26),
                  onPressed: () {
                    setState(() => selectedSong = song);
                    _navigateToPlayScreen(index);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPlayScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayScreen(
          songs: songs
              .map((s) => {
                    'title': s.title,
                    'artist': s.artist,
                    'imageUrl': s.imageUrl,
                    'audioUrl': s.audioUrl,
                  })
              .toList(),
          initialIndex: index,
          audioHandler: widget.audioHandler,
        ),
      ),
    );
  }
}
