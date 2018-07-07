import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'book_model.dart';

class BookApi {
  static const BASE_URL = 'https://www.googleapis.com/books/v1/volumes?q=';
  const BookApi();

  Future<List<Book>> searchBook(String query) async {
    final response = await http.get('$BASE_URL$query');
    final decoded = json.decode(response.body);
    if (response.statusCode != HttpStatus.OK) {
      throw new HttpException(decoded['error']['message']);
    }
    if (decoded['items'] == null) {
      throw new HttpException('Items is null');
    }
    return (decoded['items'] as Iterable)
        .cast<Map<String, dynamic>>()
        .map((json) => Book.fromJson(json))
        .toList();
  }
}
