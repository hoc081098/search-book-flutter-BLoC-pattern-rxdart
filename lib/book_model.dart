class Book {
  final String id;
  final String title;
  final String subtitle;
  final List<String> authors;
  final String thumbnail;

  Book({
    this.id,
    this.title,
    this.subtitle,
    this.authors,
    this.thumbnail,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['volumeInfo']['title'],
      subtitle: json['volumeInfo']['subtitle'],
      authors: json['volumeInfo']['authors'],
      thumbnail: json['volumeInfo']['imageLinks']['thumbnail'],
    );
  }
}
