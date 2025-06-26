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
      imageUrl: json['im:image']['label'],
    );
  }
}

// class MusicModel {
//   Feed? feed;

//   MusicModel({this.feed});

//   MusicModel.fromJson(Map<String, dynamic> json) {
//     feed = json['feed'] != null ? Feed.fromJson(json['feed']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (feed != null) {
//       data['feed'] = feed!.toJson();
//     }
//     return data;
//   }
// }

// class Feed {
//   Author? author;
//   List<Entry>? entry;
//   Name? updated;
//   Name? rights;
//   Name? title;
//   Name? icon;
//   List<Link>? link;
//   Name? id;

//   Feed(
//       {this.author,
//       this.entry,
//       this.updated,
//       this.rights,
//       this.title,
//       this.icon,
//       this.link,
//       this.id});

//   Feed.fromJson(Map<String, dynamic> json) {
//     author =
//         json['author'] != null ? Author.fromJson(json['author']) : null;
//     if (json['entry'] != null) {
//       entry = <Entry>[];
//       json['entry'].forEach((v) {
//         entry!.add(Entry.fromJson(v));
//       });
//     }
//     updated =
//         json['updated'] != null ? Name.fromJson(json['updated']) : null;
//     rights = json['rights'] != null ? Name.fromJson(json['rights']) : null;
//     title = json['title'] != null ? Name.fromJson(json['title']) : null;
//     icon = json['icon'] != null ? Name.fromJson(json['icon']) : null;
//     if (json['link'] != null) {
//       link = <Link>[];
//       json['link'].forEach((v) {
//         link!.add(Link.fromJson(v));
//       });
//     }
//     id = json['id'] != null ? Name.fromJson(json['id']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (author != null) {
//       data['author'] = author!.toJson();
//     }
//     if (entry != null) {
//       data['entry'] = entry!.map((v) => v.toJson()).toList();
//     }
//     if (updated != null) {
//       data['updated'] = updated!.toJson();
//     }
//     if (rights != null) {
//       data['rights'] = rights!.toJson();
//     }
//     if (title != null) {
//       data['title'] = title!.toJson();
//     }
//     if (icon != null) {
//       data['icon'] = icon!.toJson();
//     }
//     if (link != null) {
//       data['link'] = link!.map((v) => v.toJson()).toList();
//     }
//     if (id != null) {
//       data['id'] = id!.toJson();
//     }
//     return data;
//   }
// }

// class Author {
//   Name? name;
//   Name? uri;

//   Author({this.name, this.uri});

//   Author.fromJson(Map<String, dynamic> json) {
//     name = json['name'] != null ? Name.fromJson(json['name']) : null;
//     uri = json['uri'] != null ? Name.fromJson(json['uri']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (name != null) {
//       data['name'] = name!.toJson();
//     }
//     if (uri != null) {
//       data['uri'] = uri!.toJson();
//     }
//     return data;
//   }
// }

// class Name {
//   String? label;

//   Name({this.label});

//   Name.fromJson(Map<String, dynamic> json) {
//     label = json['label'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['label'] = label;
//     return data;
//   }
// }

// class Entry {
//   Name? imName;
//   List<ImImage>? imImage;
//   ImCollection? imCollection;
//   ImImage? imPrice;
//   Link? imContentType;
//   Name? rights;
//   Name? title;
//   List<Link>? link;
//   Name? id;
//   ImImage? imArtist;
//   Link? category;
//   ImImage? imReleaseDate;

//   Entry(
//       {this.imName,
//       this.imImage,
//       this.imCollection,
//       this.imPrice,
//       this.imContentType,
//       this.rights,
//       this.title,
//       this.link,
//       this.id,
//       this.imArtist,
//       this.category,
//       this.imReleaseDate});

//   Entry.fromJson(Map<String, dynamic> json) {
//     imName =
//         json['im:name'] != null ? Name.fromJson(json['im:name']) : null;
//     if (json['im:image'] != null) {
//       imImage = <ImImage>[];
//       json['im:image'].forEach((v) {
//         imImage!.add(ImImage.fromJson(v));
//       });
//     }
//     imCollection = json['im:collection'] != null
//         ? ImCollection.fromJson(json['im:collection'])
//         : null;
//     imPrice = json['im:price'] != null
//         ? ImImage.fromJson(json['im:price'])
//         : null;
//     imContentType = json['im:contentType'] != null
//         ? Link.fromJson(json['im:contentType'])
//         : null;
//     rights = json['rights'] != null ? Name.fromJson(json['rights']) : null;
//     title = json['title'] != null ? Name.fromJson(json['title']) : null;
//     if (json['link'] != null) {
//       link = <Link>[];
//       json['link'].forEach((v) {
//         link!.add(Link.fromJson(v));
//       });
//     }
//     id = json['id'] != null ? Name.fromJson(json['id']) : null;
//     imArtist = json['im:artist'] != null
//         ? ImImage.fromJson(json['im:artist'])
//         : null;
//     category =
//         json['category'] != null ? Link.fromJson(json['category']) : null;
//     imReleaseDate = json['im:releaseDate'] != null
//         ? ImImage.fromJson(json['im:releaseDate'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (imName != null) {
//       data['im:name'] = imName!.toJson();
//     }
//     if (imImage != null) {
//       data['im:image'] = imImage!.map((v) => v.toJson()).toList();
//     }
//     if (imCollection != null) {
//       data['im:collection'] = imCollection!.toJson();
//     }
//     if (imPrice != null) {
//       data['im:price'] = imPrice!.toJson();
//     }
//     if (imContentType != null) {
//       data['im:contentType'] = imContentType!.toJson();
//     }
//     if (rights != null) {
//       data['rights'] = rights!.toJson();
//     }
//     if (title != null) {
//       data['title'] = title!.toJson();
//     }
//     if (link != null) {
//       data['link'] = link!.map((v) => v.toJson()).toList();
//     }
//     if (id != null) {
//       data['id'] = id!.toJson();
//     }
//     if (imArtist != null) {
//       data['im:artist'] = imArtist!.toJson();
//     }
//     if (category != null) {
//       data['category'] = category!.toJson();
//     }
//     if (imReleaseDate != null) {
//       data['im:releaseDate'] = imReleaseDate!.toJson();
//     }
//     return data;
//   }
// }

// class ImImage {
//   String? label;
//   IdAttributes? attributes;

//   ImImage({this.label, this.attributes});

//   ImImage.fromJson(Map<String, dynamic> json) {
//     label = json['label'];
//     attributes = json['attributes'] != null
//         ? IdAttributes.fromJson(json['attributes'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['label'] = label;
//     if (attributes != null) {
//       data['attributes'] = attributes!.toJson();
//     }
//     return data;
//   }
// }

// class ImageAttributes {
//   String? height;

//   ImageAttributes({this.height});

//   ImageAttributes.fromJson(Map<String, dynamic> json) {
//     height = json['height'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['height'] = height;
//     return data;
//   }
// }

// class ImCollection {
//   Name? imName;
//   Link? link;
//   Link? imContentType;

//   ImCollection({this.imName, this.link, this.imContentType});

//   ImCollection.fromJson(Map<String, dynamic> json) {
//     imName =
//         json['im:name'] != null ? Name.fromJson(json['im:name']) : null;
//     link = json['link'] != null ? Link.fromJson(json['link']) : null;
//     imContentType = json['im:contentType'] != null
//         ? Link.fromJson(json['im:contentType'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (imName != null) {
//       data['im:name'] = imName!.toJson();
//     }
//     if (link != null) {
//       data['link'] = link!.toJson();
//     }
//     if (imContentType != null) {
//       data['im:contentType'] = imContentType!.toJson();
//     }
//     return data;
//   }
// }

// class Link {
//   IdAttributes? attributes;

//   Link({this.attributes});

//   Link.fromJson(Map<String, dynamic> json) {
//     attributes = json['attributes'] != null
//         ? IdAttributes.fromJson(json['attributes'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (attributes != null) {
//       data['attributes'] = attributes!.toJson();
//     }
//     return data;
//   }
// }

// class LinkAttributes {
//   String? rel;
//   String? type;
//   String? href;

//   LinkAttributes({this.rel, this.type, this.href});

//   LinkAttributes.fromJson(Map<String, dynamic> json) {
//     rel = json['rel'];
//     type = json['type'];
//     href = json['href'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['rel'] = this.rel;
//     data['type'] = this.type;
//     data['href'] = this.href;
//     return data;
//   }
// }

// class ImContentType {
//   Link? imContentType;
//   IdAttributes? attributes;

//   ImContentType({this.imContentType, this.attributes});

//   ImContentType.fromJson(Map<String, dynamic> json) {
//     imContentType = json['im:contentType'] != null
//         ? Link.fromJson(json['im:contentType'])
//         : null;
//     attributes = json['attributes'] != null
//         ? IDAttributes.fromJson(json['attributes'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     if (imContentType != null) {
//       data['im:contentType'] = imContentType!.toJson();
//     }
//     if (attributes != null) {
//       data['attributes'] = attributes!.toJson();
//     }
//     return data;
//   }
// }

class IDAttributes {}

// class ContentTypeAttributes {
//   String? term;
//   String? label;

//   ContentTypeAttributes({this.term, this.label});

//   ContentTypeAttributes.fromJson(Map<String, dynamic> json) {
//     term = json['term'];
//     label = json['label'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['term'] = this.term;
//     data['label'] = this.label;
//     return data;
//   }
// }

// class PriceAttributes {
//   String? amount;
//   String? currency;

//   PriceAttributes({this.amount, this.currency});

//   PriceAttributes.fromJson(Map<String, dynamic> json) {
//     amount = json['amount'];
//     currency = json['currency'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['amount'] = amount;
//     data['currency'] = currency;
//     return data;
//   }
// }

// class AssetAttributes {
//   String? rel;
//   String? type;
//   String? href;
//   String? title;
//   String? imAssetType;

//   AssetAttributes({this.rel, this.type, this.href, this.title, this.imAssetType});

//   AssetAttributes.fromJson(Map<String, dynamic> json) {
//     rel = json['rel'];
//     type = json['type'];
//     href = json['href'];
//     title = json['title'];
//     imAssetType = json['im:assetType'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['rel'] = this.rel;
//     data['type'] = this.type;
//     data['href'] = this.href;
//     data['title'] = this.title;
//     data['im:assetType'] = this.imAssetType;
//     return data;
//   }
// }

// class IdAttributes {
//   String? imId;
// class AssetAttributes {
//   String? rel;
//   String? type;
//   String? href;
//   String? title;
//   String? imAssetType;

//   AssetAttributes({this.rel, this.type, this.href, this.title, this.imAssetType});

//   AssetAttributes.fromJson(Map<String, dynamic> json) {
//     rel = json['rel'];
//     type = json['type'];
//     href = json['href'];
//     title = json['title'];
//     imAssetType = json['im:assetType'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['rel'] = rel;
//     data['type'] = type;
//     data['href'] = href;
//     data['title'] = title;
//     data['im:assetType'] = imAssetType;
//     return data;
//   }
// }
//   }
// class IdAttributes {
//   String? imId;

//   IdAttributes({this.imId});

//   IdAttributes.fromJson(Map<String, dynamic> json) {
//     imId = json['im:id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['im:id'] = imId;
//     return data;
//   }
// }
//   }
// class HrefAttributes {
//   String? href;

//   HrefAttributes({this.href});

//   HrefAttributes.fromJson(Map<String, dynamic> json) {
//     href = json['href'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['href'] = href;
//     return data;
//   }
// }
// class CategoryAttributes {
//   String? imId;
//   String? term;
//   String? scheme;
//   String? label;

//   CategoryAttributes({this.imId, this.term, this.scheme, this.label});

//   CategoryAttributes.fromJson(Map<String, dynamic> json) {
//     imId = json['im:id'];
//     term = json['term'];
//     scheme = json['scheme'];
//     label = json['label'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['im:id'] = this.imId;
//     data['term'] = this// .term;
//     data['scheme'] = this.scheme;
//     data['label'] = this.label;
//     return data;
//   }
// }
