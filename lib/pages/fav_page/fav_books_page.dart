import 'package:flutter/material.dart';

class FavoritedBooksPage extends StatefulWidget {
  @override
  _FavoritedBooksPageState createState() => _FavoritedBooksPageState();
}

class _FavoritedBooksPageState extends State<FavoritedBooksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorited books'),
      ),
      body: Center(
        child: Text('TODO'),
      ),
    );
  }
}
