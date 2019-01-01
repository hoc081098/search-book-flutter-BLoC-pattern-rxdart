import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:demo_bloc_pattern/model/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint;

class BookApi {
  const BookApi();

  Future<List<Book>> searchBook({String query, int startIndex: 0}) async {
    final uri = Uri.https(
      'www.googleapis.com',
      '/books/v1/volumes',
      <String, String>{
        'q': query,
        'startIndex': startIndex.toString(),
      },
    );
    debugPrint('##DEBUG $uri');
    final response = await http.get(uri);
    final decoded = json.decode(response.body);
    if (response.statusCode != HttpStatus.ok) {
      throw new HttpException(decoded['error']['message']);
    }
    final items = decoded['items'] ?? [];
    return (items as Iterable)
        .cast<Map<String, dynamic>>()
        .map((json) => Book.fromJson(json))
        .toList();
  }
}
