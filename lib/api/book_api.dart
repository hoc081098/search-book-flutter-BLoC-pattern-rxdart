import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:demo_bloc_pattern/model/book_model.dart';

class BookApi {
  static const BASE_URL = 'https://www.googleapis.com/books/v1/volumes?q=';

  const BookApi();

  Future<List<Book>> searchBook(String query) async {
    final response = await http.get('$BASE_URL$query');
    final decoded = json.decode(response.body);
    if (response.statusCode != HttpStatus.OK) {
      throw new HttpException(decoded['error']['message']);
    }
    final items = decoded['items'] ?? [];
    return (items as Iterable)
        .cast<Map<String, dynamic>>()
        .map((json) => Book.fromJson(json))
        .toList();
  }
}
