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
    final authors = json['volumeInfo']['authors'];
    final imageLinks = json['volumeInfo']['imageLinks'];
    return Book(
      id: json['id'],
      title: json['volumeInfo']['title'] ?? "",
      subtitle: json['volumeInfo']['subtitle'] ?? "",
      authors:
      authors != null ? (authors as Iterable).cast<String>() : <String>[],
      thumbnail: imageLinks != null ? imageLinks['thumbnail'] : "",
    );
  }

  @override
  String toString() => 'Book{id: $id, title: $title, subtitle: $subtitle, '
      'authors: $authors, thumbnail: $thumbnail}';
}
