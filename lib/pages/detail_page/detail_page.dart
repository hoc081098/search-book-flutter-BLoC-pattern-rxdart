import 'package:search_book/pages/detail_page/detail_bloc.dart';
import 'package:search_book/pages/detail_page/detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailPage extends StatefulWidget {
  final DetailBloc Function() initBloc;

  const DetailPage({Key key, @required this.initBloc})
      : assert(initBloc != null),
        super(key: key);

  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  DetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.initBloc();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _refreshIndicatorKey?.currentState?.show());
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
                  child: detail.largeImage != null
                      ? Image.network(
                          detail.largeImage,
                          fit: BoxFit.cover,
                          height: 300.0,
                        )
                      : Container(),
                  constraints: BoxConstraints.expand(height: 300.0),
                ),
                Container(
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
                ),
                BookDetailContent(
                  detail: detail,
                  bloc: _bloc,
                  refreshIndicatorKey: _refreshIndicatorKey,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.circle,
                  ),
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 8,
                  ),
                  child: BackButton(color: Colors.white),
                )
              ],
            ),
          ),
          floatingActionButton: detail.isFavorited == null
              ? Container(width: 0, height: 0)
              : FloatingActionButton(
                  onPressed: _bloc.toggleFavorited,
                  child: Icon(
                    detail.isFavorited ? Icons.star : Icons.star_border,
                  ),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
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
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const BookDetailContent({
    Key key,
    @required this.detail,
    @required this.bloc,
    @required this.refreshIndicatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(detail.id);
    final headerStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
    );
    final regularStyle = headerStyle.copyWith(
      fontSize: 14.0,
      color: Colors.teal.shade50,
      fontWeight: FontWeight.w400,
    );

    return RefreshIndicator(
      key: refreshIndicatorKey,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 0.0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0x8c333366),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(
                    0.0,
                    0.0,
                  ),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Hero(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      clipBehavior: Clip.antiAlias,
                      child: FadeInImage.assetNetwork(
                        image: detail.thumbnail ?? '',
                        width: 64.0 * 2,
                        height: 96.0 * 2,
                        fit: BoxFit.cover,
                        placeholder: 'assets/no_image.png',
                      ),
                    ),
                    tag: detail.id,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  detail.title ?? 'No title',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: headerStyle,
                ),
                SizedBox(height: 8),
                Text(
                  detail.subtitle ?? 'No subtitle',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: regularStyle,
                ),
                SizedBox(height: 12),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  height: 2.0,
                  width: 128.0,
                  color: Color(0xff00c6ff),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Authors: ${detail.authors?.join(', ') ?? 'No authors'}',
                              style: regularStyle,
                              maxLines: 5,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ),
                    SizedBox(width: 4.0),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Published date: ${detail.publishedDate ?? 'No published date'}',
                              style: regularStyle,
                              maxLines: 5,
                              overflow: TextOverflow.fade,
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
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 32.0),
                Text('DESCRIPTION', style: headerStyle),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  height: 2.0,
                  width: 32.0,
                  color: Color(0xff00c6ff),
                ),
                Html(
                  data: detail.description ?? 'No description',
                  defaultTextStyle: regularStyle,
                ),
              ],
            ),
          ),
          Container(height: MediaQuery.of(context).size.height / 6),
        ],
        padding: EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
      ),
      onRefresh: bloc.refresh,
    );
  }
}
