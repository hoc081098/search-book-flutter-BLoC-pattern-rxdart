import 'package:demo_bloc_pattern/pages/detail_page/detail_bloc.dart';
import 'package:demo_bloc_pattern/pages/detail_page/detail_state.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final DetailBloc Function() initBloc;

  const DetailPage({Key key, @required this.initBloc})
      : assert(initBloc != null),
        super(key: key);

  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.initBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: StreamBuilder<BookDetailState>(
        stream: _bloc.bookDetail$,
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Center(
                child: Text(snapshot.data.toString()),
              ),
              RaisedButton(
                onPressed: _bloc.toggleFavorited,
                child: Text('Toggle'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
