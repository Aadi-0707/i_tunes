import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/models/all_models.dart';
import 'package:i_tunes/view/Song_Player/play_screen.dart';
import 'package:i_tunes/view/Song_Player/audio_handler.dart';

class SearchScreen extends StatefulWidget {
  final List<SongModel> allSongs;
  final AudioPlayerHandler audioHandler;

  const SearchScreen({
    Key? key,
    required this.allSongs,
    required this.audioHandler,
  }) : super(key: key);

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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: AppBar(
          automaticallyImplyLeading: true,
          elevation: 2,
          backgroundColor: Colors.redAccent[50],
          title: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: TextField(
              controller: _controller,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Search by title or artist",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filtered.isEmpty
          ? const Center(child: Text("No songs found."))
          : ListView.builder(
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
    );
  }
}
