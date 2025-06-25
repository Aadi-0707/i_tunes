import 'package:flutter/material.dart';

class PlayScreen extends StatefulWidget {
  final String songName;

  const PlayScreen({super.key, required this.songName});

  @override
  State<PlayScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<PlayScreen> {
  double progress = 0.3;
  int currentSongIndex = 0;
  bool isPlaying = false;

  List<String> hindiSongs = [
    'Tere Liye - Veer Zaara',
    'Kal Ho Naa Ho - Kal Ho Naa Ho',
    'Tum Hi Ho - Aashiqui 2',
    'Chaiyya Chaiyya - Dil Se',
    'Raabta - Agent Vinod',
    'Bekhayali - Kabir Singh',
    'Kesariya - Brahmastra'
  ];

  @override
  void initState() {
    super.initState();
    currentSongIndex = hindiSongs.indexOf(widget.songName);
    if (currentSongIndex == -1) {
      currentSongIndex = 0;
    }
  }

  void playNext() {
    setState(() {
      currentSongIndex = (currentSongIndex + 1) % hindiSongs.length;
    });
  }

  void playPrevious() {
    setState(() {
      currentSongIndex =
          (currentSongIndex - 1 + hindiSongs.length) % hindiSongs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentSong = hindiSongs[currentSongIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Playing', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.back_hand, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              height: 400,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/singer_pic.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.9),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              currentSong,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Slider(
              value: progress,
              onChanged: (value) {},
              activeColor: Colors.redAccent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("0:39", style: TextStyle(color: Colors.grey)),
                Text("2:46", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 35),
                  onPressed: playPrevious,
                ),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 35),
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
