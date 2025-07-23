class SongModel {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;
  bool isBookmarked;

  SongModel({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
    this.isBookmarked = false,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    final String title = json['im:name']?['label'] ?? 'Unknown Title';
    final String artist = json['im:artist']?['label'] ?? 'Unknown Artist';

    String imageUrl = '';
    if (json['im:image'] is List && json['im:image'].length > 2) {
      imageUrl = json['im:image'][2]['label'] ?? '';
    }

    String audioUrl = '';
    if (json['link'] is List) {
      for (var item in json['link']) {
        if (item['attributes']?['type'] == 'audio/x-m4a') {
          audioUrl = item['attributes']['href'] ?? '';
          break;
        }
      }
    }

    return SongModel(
      title: title,
      artist: artist,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'isBookmarked': isBookmarked,
    };
  }

  factory SongModel.fromLocalJson(Map<String, dynamic> json) {
    return SongModel(
      title: json['title'] ?? 'Unknown Title',
      artist: json['artist'] ?? 'Unknown Artist',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
}
