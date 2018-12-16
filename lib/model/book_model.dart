import 'package:meta/meta.dart';

@immutable
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
    final volumeInfo = json['volumeInfo'];
    final authors = volumeInfo['authors'];
    final imageLinks = volumeInfo['imageLinks'] ?? {};

    return Book(
      id: json['id'],
      title: volumeInfo['title'] ?? '',
      subtitle: volumeInfo['subtitle'] ?? '',
      authors: authors?.cast<String>() ?? <String>[],
      thumbnail: imageLinks['thumbnail'] ?? '',
    );
  }

  @override
  String toString() => 'Book{id: $id, title: $title, subtitle: $subtitle, '
      'authors: $authors, thumbnail: $thumbnail}';
}
