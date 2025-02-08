//model for search page
class Artwork {
  String? id;
  String? title;
  String? type;
  String? thumbnail;
  String? description;
  String? og_type;
  String? artistId;
  String? showId;

  Artwork({
    this.id,
    this.title,
    this.type,
    this.thumbnail,
    this.description,
    this.og_type,
    this.artistId,
    this.showId

  });

  factory Artwork.fromMap(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      thumbnail: json['_links']['thumbnail']['href'],
      description: json['description'],
      og_type: json["og_type"],
        artistId: json["artist_id"],
      showId: json["show_id"]
    );
  }
}
