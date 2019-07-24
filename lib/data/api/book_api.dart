import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:search_book/data/api/book_response.dart';

class BookApi {
  final http.Client _client;

  const BookApi(this._client);

  Future<List<BookResponse>> searchBook({
    String query,
    int startIndex: 0,
  }) async {
    print('[API] searchBook query=$query, startIndex=$startIndex');

    final uri = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      <String, String>{
        'q': query,
        'startIndex': startIndex.toString(),
      },
    );

    final response = await _client.get(uri);
    final decoded = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode != HttpStatus.ok) {
      throw new HttpException(decoded['error']['message']);
    }
    final items = decoded['items'] ?? [];
    return (items as Iterable)
        .cast<Map<String, dynamic>>()
        .map((json) => BookResponse.fromJson(json))
        .toList();
  }

  Future<BookResponse> getBookById(String id) async {
    final uri = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes/$id',
    );

    final response = await _client.get(uri);
    final decoded = json.decode(response.body);

    if (response.statusCode != HttpStatus.ok) {
      throw new HttpException(decoded['error']['message']);
    }

    return BookResponse.fromJson(decoded);
  }
}
