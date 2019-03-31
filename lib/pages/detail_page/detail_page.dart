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
    _bloc.refresh().then((_) => print('[DETAIL] done'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BookDetailState>(
      stream: _bloc.bookDetail$,
      initialData: _bloc.bookDetail$.value,
      builder: (context, snapshot) {
        final detail = snapshot.data;

        return Scaffold(
          body: Container(
            color: Color(0xFF736AB7),
            constraints: BoxConstraints.expand(),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Image.network(
                    detail?.largeImage ?? '',
                    fit: BoxFit.cover,
                    height: 300.0,
                  ),
                  constraints: new BoxConstraints.expand(height: 300.0),
                ),
                _getGradient(),
                BookDetailContent(
                  detail: detail,
                  bloc: _bloc,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: BackButton(color: Colors.white),
                )
              ],
            ),
          ),
          floatingActionButton: detail == null
              ? Container(width: 0, height: 0)
              : FloatingActionButton(
                  onPressed: _bloc.toggleFavorited,
                  child: Icon(
                    detail.isFavorited ? Icons.star : Icons.star_border,
                    color: Colors.white,
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _getGradient() {
    return Container(
      margin: EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0x00736AB7),
            Color(0xFF736AB7),
          ],
          stops: [0.0, 0.9],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomStart,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

class BookDetailContent extends StatelessWidget {
  final BookDetailState detail;
  final DetailBloc bloc;

  const BookDetailContent({
    Key key,
    @required this.detail,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
    );
    final regularStyle = headerStyle.copyWith(
      fontSize: 14.0,
      color: Color(0xffb6b2df),
      fontWeight: FontWeight.w400,
    );

    final titleText = Text(
      detail?.title ?? 'Loading...',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: headerStyle,
    );

    final subtitleText = Text(
      detail?.subtitle == null
          ? 'Loading...'
          : detail.subtitle.isEmpty ? 'No subtitle...' : detail.subtitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: regularStyle,
    );

    final thumbnail = Container(
      margin: new EdgeInsets.only(bottom: 92.0),
      alignment: AlignmentDirectional.center,
      child: Hero(
        child: FadeInImage.assetNetwork(
          image: detail?.thumbnail ?? '',
          width: 64.0 * 1.75,
          height: 96.0 * 1.75,
          fit: BoxFit.cover,
          placeholder: 'assets/no_image.png',
        ),
        tag: detail.id,
      ),
    );
    final cardContent = Container(
      margin: EdgeInsets.only(top: 144.0),
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 4.0),
          titleText,
          SizedBox(height: 4.0),
          subtitleText,
          SizedBox(height: 8.0),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            height: 2.0,
            width: 128.0,
            color: Color(0xff00c6ff),
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new Row(
                  children: <Widget>[
                    Icon(
                      Icons.thumb_up,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'VOTE COUNT',
                      style: regularStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              SizedBox(width: 4.0),
              new Expanded(
                child: new Row(
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(width: 8.0),
                    new Center(
                      child: Text(
                        'RELEASE DATE',
                        style: regularStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    final card = Container(
      margin: EdgeInsets.only(bottom: 0.0),
      decoration: BoxDecoration(
        color: Color(0x8c333366),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 0.0),
          )
        ],
      ),
      child: cardContent,
    );
    var item = Container(
      height: 300.0,
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0),
      child: Stack(
        children: <Widget>[card, thumbnail],
      ),
    );

    return new RefreshIndicator(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          item,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 16.0,
                ),
                Text('OVERVIEW', style: headerStyle),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    height: 2.0,
                    width: 32.0,
                    color: Color(0xff00c6ff)),
                Text('OVERVIEW', style: regularStyle),
              ],
            ),
          ),
        ],
        padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
      ),
      onRefresh: bloc.refresh,
    );
  }
}
