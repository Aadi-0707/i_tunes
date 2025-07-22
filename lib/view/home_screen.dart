import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:i_tunes/view/Song_Player/play_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final AudioPlayerHandler audioHandler;
  final List<SongModel> playlist;
  final Function(List<SongModel>) onPlaylistChanged;
  final Function(Map<String, String>, bool) onMinimize;

  const HomeScreen({
    super.key,
    required this.audioHandler,
    required this.playlist,
    required this.onPlaylistChanged,
    required this.onMinimize,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<SongModel> songs = [];
  SongModel? selectedSong;
  List<SongModel> filteredSongs = [];
  String selectedCategory = 'All';

  List<String> categories = [
    'All',
    'Punjabi',
    'Gujarati',
    'Hindi',
    'English',
    'Lofi',
    'Drive',
    'Relax',
    'Party'
  ];

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
      updatedList.removeWhere((s) => s.audioUrl == song.audioUrl);
      song.isBookmarked = false;
      _showSnackBar('Removed from Playlist', Colors.red);
    } else {
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

  void filterSongs(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredSongs = List.from(songs);
      } else {
        filteredSongs = songs.where((song) {
          return song.title.toLowerCase().contains(category.toLowerCase()) ||
              song.artist.toLowerCase().contains(category.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                'assets/images/logo2.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome,',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'iTunes Music',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.search, color: Colors.black, size: 28),
                      ],
                    ),
                  ),
                ),
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.redAccent[50],
                  toolbarHeight: 35.h,
                  automaticallyImplyLeading: false,
                  title: SizedBox(
                    height: 30.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        String category = categories[index];
                        bool isSelected = category == selectedCategory;

                        return GestureDetector(
                          onTap: () => filterSongs(category),
                          child: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(255, 183, 36, 23)
                                  : Colors.black45,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Center(
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      SongModel song = selectedCategory == 'All'
                          ? songs[index]
                          : filteredSongs[index];
                      return _buildSongCard(song, index);
                    },
                    childCount: selectedCategory == 'All'
                        ? songs.length
                        : filteredSongs.length,
                  ),
                ),
              ],
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
            leading: Hero(
              tag: 'artwork_${song.audioUrl}',
              child: CircleAvatar(backgroundImage: NetworkImage(song.imageUrl)),
            ),
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
          onMinimize: (currentSong, isPlaying) {
            widget.onMinimize(currentSong, isPlaying);
          },
        ),
      ),
    );
  }
}
