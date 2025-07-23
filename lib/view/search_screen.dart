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
      backgroundColor: Colors.redAccent[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Padding(
          padding: EdgeInsets.only(top: 40.h, right: 10.w),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.black87,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w, bottom: 5.h),
                  child: Container(
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: TextField(
                              controller: _controller,
                              cursorColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Search songs, artists, podcasts...',
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.mic, color: Colors.black),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _filtered.isEmpty
          ? const Center(
              child: Text(
                "No songs found.",
                style: TextStyle(color: Colors.black),
              ),
            )
          : ListView.builder(
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final song = _filtered[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.imageUrl),
                  ),
                  title: Text(song.title,
                      style: const TextStyle(color: Colors.black)),
                  subtitle: Text(song.artist,
                      style: TextStyle(color: Colors.grey[600])),
                  onTap: () => _playSong(index),
                );
              },
            ),
    );
  }
}
