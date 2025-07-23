import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:i_tunes/models/models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';
import 'package:i_tunes/view/Song_Player/play_screen.dart';

class PlaylistScreen extends StatefulWidget {
  final List<SongModel> playlistSongs;
  final Function(List<SongModel>) onPlaylistChanged;
  final AudioPlayerHandler audioHandler;
  final Function(Map<String, String>, bool) onMinimize;

  const PlaylistScreen({
    super.key,
    required this.playlistSongs,
    required this.onPlaylistChanged,
    required this.audioHandler,
    required this.onMinimize,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late List<SongModel> playlistSongs;

  @override
  void initState() {
    super.initState();
    playlistSongs = List.from(widget.playlistSongs);
  }

  void removeFromPlaylist(SongModel song) {
    setState(() {
      playlistSongs.removeWhere((element) => element.audioUrl == song.audioUrl);
      song.isBookmarked = false;
    });

    widget.onPlaylistChanged(List.from(playlistSongs));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from Playlist',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant PlaylistScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playlistSongs != widget.playlistSongs) {
      setState(() {
        playlistSongs = List.from(widget.playlistSongs);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent[50],
        elevation: 0,
        title:
            const Text(' My Playlist', style: TextStyle(color: Colors.black)),
      ),
      body: playlistSongs.isEmpty
          ? const Center(
              child: Text("Your playlist is empty",
                  style: TextStyle(fontSize: 18, color: Colors.black54)),
            )
          : ListView.builder(
              itemCount: playlistSongs.length,
              itemBuilder: (context, index) {
                final song = playlistSongs[index];

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
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(song.imageUrl),
                          ),
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
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: () => removeFromPlaylist(song),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 26),
                              onPressed: () => _openPlayer(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _openPlayer(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayScreen(
          songs: playlistSongs
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
