import 'package:flutter/material.dart';

class LocalSongScreen extends StatefulWidget {
  const LocalSongScreen({super.key});

  @override
  State<LocalSongScreen> createState() => _LocalSongScreenState();
}

class _LocalSongScreenState extends State<LocalSongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent[50],
      appBar: AppBar(
        title: const Text(' Local Songs'),
        backgroundColor: Colors.redAccent[50],
        elevation: 0,
      ),
    );
  }
}
