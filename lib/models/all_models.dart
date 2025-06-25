// class MusicModel {
//   Feed? feed;

//   MusicModel({this.feed});

//   MusicModel.fromJson(Map<String, dynamic> json) {
//     feed = json['feed'] != null ? new Feed.fromJson(json['feed']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.feed != null) {
//       data['feed'] = this.feed!.toJson();
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
//         json['author'] != null ? new Author.fromJson(json['author']) : null;
//     if (json['entry'] != null) {
//       entry = <Entry>[];
//       json['entry'].forEach((v) {
//         entry!.add(new Entry.fromJson(v));
//       });
//     }
//     updated =
//         json['updated'] != null ? new Name.fromJson(json['updated']) : null;
//     rights = json['rights'] != null ? new Name.fromJson(json['rights']) : null;
//     title = json['title'] != null ? new Name.fromJson(json['title']) : null;
//     icon = json['icon'] != null ? new Name.fromJson(json['icon']) : null;
//     if (json['link'] != null) {
//       link = <Link>[];
//       json['link'].forEach((v) {
//         link!.add(new Link.fromJson(v));
//       });
//     }
//     id = json['id'] != null ? new Name.fromJson(json['id']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.author != null) {
//       data['author'] = this.author!.toJson();
//     }
//     if (this.entry != null) {
//       data['entry'] = this.entry!.map((v) => v.toJson()).toList();
//     }
//     if (this.updated != null) {
//       data['updated'] = this.updated!.toJson();
//     }
//     if (this.rights != null) {
//       data['rights'] = this.rights!.toJson();
//     }
//     if (this.title != null) {
//       data['title'] = this.title!.toJson();
//     }
//     if (this.icon != null) {
//       data['icon'] = this.icon!.toJson();
//     }
//     if (this.link != null) {
//       data['link'] = this.link!.map((v) => v.toJson()).toList();
//     }
//     if (this.id != null) {
//       data['id'] = this.id!.toJson();
//     }
//     return data;
//   }
// }

// class Author {
//   Name? name;
//   Name? uri;

//   Author({this.name, this.uri});

//   Author.fromJson(Map<String, dynamic> json) {
//     name = json['name'] != null ? new Name.fromJson(json['name']) : null;
//     uri = json['uri'] != null ? new Name.fromJson(json['uri']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.name != null) {
//       data['name'] = this.name!.toJson();
//     }
//     if (this.uri != null) {
//       data['uri'] = this.uri!.toJson();
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
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['label'] = this.label;
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
//         json['im:name'] != null ? new Name.fromJson(json['im:name']) : null;
//     if (json['im:image'] != null) {
//       imImage = <ImImage>[];
//       json['im:image'].forEach((v) {
//         imImage!.add(new ImImage.fromJson(v));
//       });
//     }
//     imCollection = json['im:collection'] != null
//         ? new ImCollection.fromJson(json['im:collection'])
//         : null;
//     imPrice = json['im:price'] != null
//         ? new ImImage.fromJson(json['im:price'])
//         : null;
//     imContentType = json['im:contentType'] != null
//         ? new Link.fromJson(json['im:contentType'])
//         : null;
//     rights = json['rights'] != null ? new Name.fromJson(json['rights']) : null;
//     title = json['title'] != null ? new Name.fromJson(json['title']) : null;
//     if (json['link'] != null) {
//       link = <Link>[];
//       json['link'].forEach((v) {
//         link!.add(new Link.fromJson(v));
//       });
//     }
//     id = json['id'] != null ? new Name.fromJson(json['id']) : null;
//     imArtist = json['im:artist'] != null
//         ? new ImImage.fromJson(json['im:artist'])
//         : null;
//     category =
//         json['category'] != null ? new Link.fromJson(json['category']) : null;
//     imReleaseDate = json['im:releaseDate'] != null
//         ? new ImImage.fromJson(json['im:releaseDate'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.imName != null) {
//       data['im:name'] = this.imName!.toJson();
//     }
//     if (this.imImage != null) {
//       data['im:image'] = this.imImage!.map((v) => v.toJson()).toList();
//     }
//     if (this.imCollection != null) {
//       data['im:collection'] = this.imCollection!.toJson();
//     }
//     if (this.imPrice != null) {
//       data['im:price'] = this.imPrice!.toJson();
//     }
//     if (this.imContentType != null) {
//       data['im:contentType'] = this.imContentType!.toJson();
//     }
//     if (this.rights != null) {
//       data['rights'] = this.rights!.toJson();
//     }
//     if (this.title != null) {
//       data['title'] = this.title!.toJson();
//     }
//     if (this.link != null) {
//       data['link'] = this.link!.map((v) => v.toJson()).toList();
//     }
//     if (this.id != null) {
//       data['id'] = this.id!.toJson();
//     }
//     if (this.imArtist != null) {
//       data['im:artist'] = this.imArtist!.toJson();
//     }
//     if (this.category != null) {
//       data['category'] = this.category!.toJson();
//     }
//     if (this.imReleaseDate != null) {
//       data['im:releaseDate'] = this.imReleaseDate!.toJson();
//     }
//     return data;
//   }
// }

// class ImImage {
//   String? label;
//   Attributes? attributes;

//   ImImage({this.label, this.attributes});

//   ImImage.fromJson(Map<String, dynamic> json) {
//     label = json['label'];
//     attributes = json['attributes'] != null
//         ? new Attributes.fromJson(json['attributes'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['label'] = this.label;
//     if (this.attributes != null) {
//       data['attributes'] = this.attributes!.toJson();
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
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['height'] = this.height;
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
//         json['im:name'] != null ? new Name.fromJson(json['im:name']) : null;
//     link = json['link'] != null ? new Link.fromJson(json['link']) : null;
//     imContentType = json['im:contentType'] != null
//         ? new Link.fromJson(json['im:contentType'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.imName != null) {
//       data['im:name'] = this.imName!.toJson();
//     }
//     if (this.link != null) {
//       data['link'] = this.link!.toJson();
//     }
//     if (this.imContentType != null) {
//       data['im:contentType'] = this.imContentType!.toJson();
//     }
//     return data;
//   }
// }

// class Link {
//   Attributes? attributes;

//   Link({this.attributes});

//   Link.fromJson(Map<String, dynamic> json) {
//     attributes = json['attributes'] != null
//         ? new Attributes.fromJson(json['attributes'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.attributes != null) {
//       data['attributes'] = this.attributes!.toJson();
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
//   Attributes? attributes;

//   ImContentType({this.imContentType, this.attributes});

//   ImContentType.fromJson(Map<String, dynamic> json) {
//     imContentType = json['im:contentType'] != null
//         ? new Link.fromJson(json['im:contentType'])
//         : null;
//     attributes = json['attributes'] != null
//         ? new Attributes.fromJson(json['attributes'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.imContentType != null) {
//       data['im:contentType'] = this.imContentType!.toJson();
//     }
//     if (this.attributes != null) {
//       data['attributes'] = this.attributes!.toJson();
//     }
//     return data;
//   }
// }

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
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['amount'] = this.amount;
//     data['currency'] = this.currency;
//     return data;
//   }
// }

// class Link {
//   Attributes? attributes;
//   Name? imDuration;

//   Link({this.attributes, this.imDuration});

//   Link.fromJson(Map<String, dynamic> json) {
//     attributes = json['attributes'] != null
//         ? new Attributes.fromJson(json['attributes'])
//         : null;
//     imDuration = json['im:duration'] != null
//         ? new Name.fromJson(json['im:duration'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.attributes != null) {
//       data['attributes'] = this.attributes!.toJson();
//     }
//     if (this.imDuration != null) {
//       data['im:duration'] = this.imDuration!.toJson();
//     }
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

//   IdAttributes({this.imId});

//   IdAttributes.fromJson(Map<String, dynamic> json) {
//     imId = json['im:id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['im:id'] = this.imId;
//     return data;
//   }
// }

// class HrefAttributes {
//   String? href;

//   HrefAttributes({this.href});

//   HrefAttributes.fromJson(Map<String, dynamic> json) {
//     href = json['href'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['href'] = this.href;
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
//     data['term'] = this.term;
//     data['scheme'] = this.scheme;
//     data['label'] = this.label;
//     return data;
//   }
// }
