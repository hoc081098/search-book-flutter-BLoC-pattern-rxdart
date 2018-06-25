import 'package:flutter/material.dart';

import 'book_api.dart';
import 'book_bloc.dart';
import 'book_bloc_provider.dart';
import 'book_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return BookBlocProvider(
        bloc: BookBloc(BookApi()),
        child: MaterialApp(
          title: 'Demo bloc pattern',
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: new MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final BookBloc bloc = BookBlocProvider.of(context);

    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: <Color>[
              Colors.blue.withOpacity(0.8),
              Colors.purple.withOpacity(0.6),
            ],
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            stops: <double>[0.2, 0.8],
          ),
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextField(
                decoration: InputDecoration(
                  labelText: 'Search book...',
                  contentPadding: EdgeInsets.all(8.0),
                  filled: true,
                  prefixIcon: Icon(Icons.book),
                ),
                maxLines: 1,
                onChanged: bloc.query.add,
              ),
            ),
            new Expanded(
              child: new StreamBuilder<List<Book>>(
                stream: bloc.books,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
                  if (snapshot.hasError) {
                    return new Center(
                      child: new Text(
                        snapshot.error.toString(),
                        style: Theme.of(context).textTheme.body1,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                  return _buildListBook(snapshot.data);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListBook(List<Book> data) {
    return new ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => _buildBookItem(data[index]),
    );
  }

  _buildBookItem(Book book) {
    return new Row(
      children: <Widget>[
        new Image.network(
          book.thumbnail,
          width: 128.0,
          height: 192.0,
          fit: BoxFit.cover,
        ),
        new ExpansionTile(
          title: new ListTile(
            title: new Text(book.title),
            subtitle: new Text(book.subtitle),
          ),
          children:
              book.authors.map<Widget>((author) => new Text(author)).toList(),
        ),
      ],
    );
  }
}
