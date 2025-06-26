class SongModel {
  final String title;
  final String artist;
  final String imageUrl;

  SongModel({
    required this.title,
    required this.artist,
    required this.imageUrl,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      title: json['im:name']['label'],
      artist: json['im:artist']['label'],
      imageUrl: json['im:image'][2]['label'],
    );
  }
}
