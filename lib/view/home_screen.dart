import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_tunes/view/play_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> songs = [
      'Tere Liye - Veer Zaara',
      'Kal Ho Naa Ho - Kal Ho Naa Ho',
      'Tum Hi Ho - Aashiqui 2',
      'Chaiyya Chaiyya - Dil Se',
      'Raabta - Agent Vinod',
      'Bekhayali - Kabir Singh',
      'Kesariya - Brahmastra',
      'Tere Liye - Veer Zaara',
      'Kal Ho Naa Ho - Kal Ho Naa Ho',
      'Tum Hi Ho - Aashiqui 2',
      'Chaiyya Chaiyya - Dil Se',
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60.w),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0.w),
                child: Row(
                  children: [
                    Hero(
                      tag: 'albumArt',
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.w),
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.r),
                            image: DecorationImage(
                              image: AssetImage('assets/images/singer_pic.jpg'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.8),
                                  blurRadius: 20.r,
                                  offset: Offset(0, 6.h)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'Artist Name',
                          style: TextStyle(
                              fontSize: 22.sp, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Song Name'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.play_circle_fill,
                          color: Colors.redAccent, size: 36.h),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayScreen(songName: songs[0]),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text('7 songs - 22 Minutes',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(Icons.music_note, color: Colors.redAccent),
                      title: Text(songs[index]),
                      trailing: Icon(Icons.play_arrow),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayScreen(songName: songs[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
