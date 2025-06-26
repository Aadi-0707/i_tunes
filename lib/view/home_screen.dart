import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/view/play_screen.dart';
import 'package:marquee/marquee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  List<String> songs = [
    'Tere Liye - Veer Zaara',
    'Kal Ho Naa Ho - Kal Ho Naa Ho',
    'Tum Hi Ho - Aashiqui 2',
    'Chaiyya Chaiyya - Dil Se',
    'Raabta - Agent Vinod',
    'Bekhayali - Kabir Singh',
    'Kesariya - Brahmastra'
  ];

  String? selectedSong;

  @override
  void initState() {
    super.initState();
    selectedSong = songs[0];
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
                        return _buildSecondCard(songs[index], index);
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _buildFirstCard(String song) {
    return Stack(
      children: [
        Container(
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
                padding: EdgeInsets.all(15.0.w),
                child: Row(
                  children: [
                    Hero(
                      tag: 'albumArt',
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.r),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/singer_pic.jpg'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 20.r,
                                offset: Offset(0, 6.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: SizedBox(
                          height: 25.h,
                          child: Marquee(
                            text: song,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            blankSpace: 40.0,
                            velocity: 40.0,
                            pauseAfterRound: Duration(seconds: 1),
                            startPadding: 10.0,
                          ),
                        ),
                        subtitle: const Text('Artist Name',
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.play_circle_fill,
                          color: Colors.white, size: 36.h),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayScreen(songName: song),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondCard(String songs, int index) {
    return Stack(
      children: [
        Container(
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
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/singer_pic.jpg'),
                ),
                title: Text(songs, style: const TextStyle(color: Colors.white)),
                subtitle: const Text('Artist Name',
                    style: TextStyle(color: Colors.white70)),
                trailing: const Icon(Icons.play_arrow, color: Colors.white),
                onTap: () {
                  setState(() {
                    selectedSong = songs;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayScreen(songName: songs),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
