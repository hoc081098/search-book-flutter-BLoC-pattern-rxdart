import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';

@immutable
class Book {
  final String id;
  final String title;
  final String subtitle;
  final List<String> authors;
  final String thumbnail;
  final String largeImage;
  final String description;
  final String publishedDate;

  Book({
    @required this.id,
    @required this.title,
    @required this.subtitle,
    @required this.authors,
    @required this.thumbnail,
    @required this.largeImage,
    @required this.description,
    @required this.publishedDate,
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
      largeImage: imageLinks['small'] ?? '',
      description: volumeInfo['description'],
      publishedDate: volumeInfo['publishedDate'],
    );
  }

  @override
  String toString() => (newBuiltValueToStringHelper('Book')
        ..add('id', id)
        ..add('title', title)
        ..add('subtitle', subtitle)
        ..add('authors', authors)
        ..add('thumbnail', thumbnail)
        ..add('largeImage', largeImage)
        ..add('description', description)
        ..add('publishedDate', publishedDate))
      .toString();
}
