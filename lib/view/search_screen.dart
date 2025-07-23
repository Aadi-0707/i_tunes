// search_screen.dart
import 'package:flutter/material.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/Song_Player/play_screen.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';

class SearchScreen extends StatefulWidget {
  final List<SongModel> allSongs;
  final AudioPlayerHandler audioHandler;

  const SearchScreen({
    super.key,
    required this.allSongs,
    required this.audioHandler,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SongModel> _filtered = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.allSongs;
    _controller.addListener(_search);
  }

  void _search() {
    final q = _controller.text.toLowerCase();
    setState(() {
      _filtered = widget.allSongs.where((s) {
        return s.title.toLowerCase().contains(q) ||
            s.artist.toLowerCase().contains(q);
      }).toList();
    });
  }

  void _playSong(int index) {
    final mapped = _filtered
        .map((s) => {
              'title': s.title,
              'artist': s.artist,
              'imageUrl': s.imageUrl,
              'audioUrl': s.audioUrl,
            })
        .toList();

    widget.audioHandler.initializeAudioSource(mapped, index);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayScreen(
          songs: mapped,
          initialIndex: index,
          audioHandler: widget.audioHandler,
          onMinimize: (_, __) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Songs")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Search by title or artist",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final song = _filtered[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.imageUrl),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.artist),
                  onTap: () => _playSong(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
