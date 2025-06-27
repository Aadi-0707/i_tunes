// class SongModel {
//   final String title;
//   final String artist;
//   final String imageUrl;

//   SongModel({
//     required this.title,
//     required this.artist,
//     required this.imageUrl,
//   });

//   factory SongModel.fromJson(Map<String, dynamic> json) {
//     String title = json['im:name']?['label'] ?? 'Unknown Title';
//     String artist = json['im:artist']?['label'] ?? 'Unknown Artist';
//     String imageUrl = '';

//     if (json['im:image'] is List && (json['im:image'] as List).length > 2) {
//       imageUrl = json['im:image'][2]['label'] ?? '';
//     }

//     return SongModel(
//       title: title,
//       artist: artist,
//       imageUrl: imageUrl,
//     );
//   }
// }
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
    final String title = json['im:name']?['label'] ?? 'Unknown Title';
    final String artist = json['im:artist']?['label'] ?? 'Unknown Artist';
    String imageUrl = '';

    if (json['im:image'] is List) {
      final List<dynamic> images = json['im:image'];
      if (images.length > 2 && images[2] is Map<String, dynamic>) {
        imageUrl = images[2]['label'] ?? '';
      }
    }

    return SongModel(
      title: title,
      artist: artist,
      imageUrl: imageUrl,
    );
  }
}
