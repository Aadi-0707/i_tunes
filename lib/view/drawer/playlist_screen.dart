import 'package:flutter/material.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/song%20player/play_screen.dart';
import 'package:i_tunes/widget/audio_handler.dart';

class PlaylistScreen extends StatelessWidget {
  final List<SongModel> playlistSongs;
  final Function(List<SongModel>) onPlaylistChanged;
  final AudioPlayerHandler audioHandler;

  const PlaylistScreen({
    super.key,
    required this.playlistSongs,
    required this.onPlaylistChanged,
    required this.audioHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Playlist')),
      body: playlistSongs.isEmpty
          ? const Center(child: Text('No songs in playlist'))
          : ListView.builder(
              itemCount: playlistSongs.length,
              itemBuilder: (context, index) {
                final song = playlistSongs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.imageUrl),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      final updatedList = List<SongModel>.from(playlistSongs);
                      updatedList.removeAt(index);
                      onPlaylistChanged(updatedList);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayScreen(
                          songs: playlistSongs
                              .map((song) => {
                                    'title': song.title,
                                    'artist': song.artist,
                                    'imageUrl': song.imageUrl,
                                    'audioUrl': song.audioUrl,
                                  })
                              .toList(),
                          initialIndex: index,
                          audioHandler: audioHandler,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
