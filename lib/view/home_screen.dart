import 'package:flutter/material.dart';
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
      'Kesariya - Brahmastra'
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'albumArt',
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/singer_pic.jpg'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      'Artist Name',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Song Name'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.play_circle_fill,
                      color: Colors.redAccent, size: 36),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayScreen(songName: songs[0]),
                      ),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text('7 songs - 22 Minutes',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) => ListTile(
                  leading: Icon(Icons.music_note, color: Colors.redAccent),
                  title: Text(songs[index]),
                  trailing: const Icon(Icons.play_arrow),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
