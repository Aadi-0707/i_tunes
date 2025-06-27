import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayScreen extends StatefulWidget {
  final List<Map<String, String>> songs;
  final int initialIndex;

  const PlayScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late int currentSongIndex;
  double progress = 15.0;
  bool isPlaying = false;
  double totalDuration = 166.0;

  @override
  void initState() {
    super.initState();
    currentSongIndex = widget.initialIndex;
  }

  void playNext() {
    setState(() {
      currentSongIndex = (currentSongIndex + 1) % widget.songs.length;
    });
  }

  void playPrevious() {
    setState(() {
      currentSongIndex =
          (currentSongIndex - 1 + widget.songs.length) % widget.songs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songs[currentSongIndex];

    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent[50],
        elevation: 0,
        title: const Text('Playing', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Container(
              height: 300.h,
              width: 300.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  image: NetworkImage(currentSong['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20.r,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              currentSong['title'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              currentSong['artist'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                const Text("0:39", style: TextStyle(color: Colors.grey)),
                Expanded(
                  child: Slider(
                    value: progress,
                    min: 0.0,
                    max: totalDuration,
                    onChanged: (value) {
                      setState(() {
                        progress = value;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                ),
                const Text("3:46", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, size: 35.w),
                  onPressed: playPrevious,
                ),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.red,
                    size: 60.w,
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, size: 35.w),
                  onPressed: playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
