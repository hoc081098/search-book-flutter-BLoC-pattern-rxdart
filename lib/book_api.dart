import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'book_model.dart';

class BookApi {
  static const BASE_URL = 'https://www.googleapis.com/books/v1/volumes?q=';
  const BookApi();

  Future<Stream<List<Book>>> searchBook(String query) async {
    final streamedResponse =
        await http.Request('GET', Uri.parse(BASE_URL + query)).send();
    return streamedResponse.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((dynamic json) => json['items'] as Iterable)
        .map((list) => list.map((json) => Book.fromJson(json)).toList());
  }
}
