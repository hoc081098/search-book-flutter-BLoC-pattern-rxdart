// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookItem extends BookItem {
  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String thumbnail;
  @override
  final bool isFavorited;

  factory _$BookItem([void updates(BookItemBuilder b)]) =>
      (new BookItemBuilder()..update(updates)).build();

  _$BookItem._(
      {this.id, this.title, this.subtitle, this.thumbnail, this.isFavorited})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('BookItem', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('BookItem', 'title');
    }
    if (subtitle == null) {
      throw new BuiltValueNullFieldError('BookItem', 'subtitle');
    }
    if (thumbnail == null) {
      throw new BuiltValueNullFieldError('BookItem', 'thumbnail');
    }
  }

  @override
  BookItem rebuild(void updates(BookItemBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  BookItemBuilder toBuilder() => new BookItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookItem &&
        id == other.id &&
        title == other.title &&
        subtitle == other.subtitle &&
        thumbnail == other.thumbnail &&
        isFavorited == other.isFavorited;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), title.hashCode), subtitle.hashCode),
            thumbnail.hashCode),
        isFavorited.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BookItem')
          ..add('id', id)
          ..add('title', title)
          ..add('subtitle', subtitle)
          ..add('thumbnail', thumbnail)
          ..add('isFavorited', isFavorited))
        .toString();
  }
}

class BookItemBuilder implements Builder<BookItem, BookItemBuilder> {
  _$BookItem _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _subtitle;
  String get subtitle => _$this._subtitle;
  set subtitle(String subtitle) => _$this._subtitle = subtitle;

  String _thumbnail;
  String get thumbnail => _$this._thumbnail;
  set thumbnail(String thumbnail) => _$this._thumbnail = thumbnail;

  bool _isFavorited;
  bool get isFavorited => _$this._isFavorited;
  set isFavorited(bool isFavorited) => _$this._isFavorited = isFavorited;

  BookItemBuilder();

  BookItemBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _subtitle = _$v.subtitle;
      _thumbnail = _$v.thumbnail;
      _isFavorited = _$v.isFavorited;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BookItem;
  }

  @override
  void update(void updates(BookItemBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$BookItem build() {
    final _$result = _$v ??
        new _$BookItem._(
            id: id,
            title: title,
            subtitle: subtitle,
            thumbnail: thumbnail,
            isFavorited: isFavorited);
    replace(_$result);
    return _$result;
  }
}

class _$HomePageState extends HomePageState {
  @override
  final String resultText;
  @override
  final BuiltList<BookItem> books;
  @override
  final bool isFirstPageLoading;
  @override
  final Object loadFirstPageError;
  @override
  final bool isNextPageLoading;
  @override
  final Object loadNextPageError;

  factory _$HomePageState([void updates(HomePageStateBuilder b)]) =>
      (new HomePageStateBuilder()..update(updates)).build();

  _$HomePageState._(
      {this.resultText,
      this.books,
      this.isFirstPageLoading,
      this.loadFirstPageError,
      this.isNextPageLoading,
      this.loadNextPageError})
      : super._() {
    if (resultText == null) {
      throw new BuiltValueNullFieldError('HomePageState', 'resultText');
    }
    if (books == null) {
      throw new BuiltValueNullFieldError('HomePageState', 'books');
    }
    if (isFirstPageLoading == null) {
      throw new BuiltValueNullFieldError('HomePageState', 'isFirstPageLoading');
    }
    if (isNextPageLoading == null) {
      throw new BuiltValueNullFieldError('HomePageState', 'isNextPageLoading');
    }
  }

  @override
  HomePageState rebuild(void updates(HomePageStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  HomePageStateBuilder toBuilder() => new HomePageStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomePageState &&
        resultText == other.resultText &&
        books == other.books &&
        isFirstPageLoading == other.isFirstPageLoading &&
        loadFirstPageError == other.loadFirstPageError &&
        isNextPageLoading == other.isNextPageLoading &&
        loadNextPageError == other.loadNextPageError;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, resultText.hashCode), books.hashCode),
                    isFirstPageLoading.hashCode),
                loadFirstPageError.hashCode),
            isNextPageLoading.hashCode),
        loadNextPageError.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('HomePageState')
          ..add('resultText', resultText)
          ..add('books', books)
          ..add('isFirstPageLoading', isFirstPageLoading)
          ..add('loadFirstPageError', loadFirstPageError)
          ..add('isNextPageLoading', isNextPageLoading)
          ..add('loadNextPageError', loadNextPageError))
        .toString();
  }
}

class HomePageStateBuilder
    implements Builder<HomePageState, HomePageStateBuilder> {
  _$HomePageState _$v;

  String _resultText;
  String get resultText => _$this._resultText;
  set resultText(String resultText) => _$this._resultText = resultText;

  ListBuilder<BookItem> _books;
  ListBuilder<BookItem> get books =>
      _$this._books ??= new ListBuilder<BookItem>();
  set books(ListBuilder<BookItem> books) => _$this._books = books;

  bool _isFirstPageLoading;
  bool get isFirstPageLoading => _$this._isFirstPageLoading;
  set isFirstPageLoading(bool isFirstPageLoading) =>
      _$this._isFirstPageLoading = isFirstPageLoading;

  Object _loadFirstPageError;
  Object get loadFirstPageError => _$this._loadFirstPageError;
  set loadFirstPageError(Object loadFirstPageError) =>
      _$this._loadFirstPageError = loadFirstPageError;

  bool _isNextPageLoading;
  bool get isNextPageLoading => _$this._isNextPageLoading;
  set isNextPageLoading(bool isNextPageLoading) =>
      _$this._isNextPageLoading = isNextPageLoading;

  Object _loadNextPageError;
  Object get loadNextPageError => _$this._loadNextPageError;
  set loadNextPageError(Object loadNextPageError) =>
      _$this._loadNextPageError = loadNextPageError;

  HomePageStateBuilder();

  HomePageStateBuilder get _$this {
    if (_$v != null) {
      _resultText = _$v.resultText;
      _books = _$v.books?.toBuilder();
      _isFirstPageLoading = _$v.isFirstPageLoading;
      _loadFirstPageError = _$v.loadFirstPageError;
      _isNextPageLoading = _$v.isNextPageLoading;
      _loadNextPageError = _$v.loadNextPageError;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomePageState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$HomePageState;
  }

  @override
  void update(void updates(HomePageStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$HomePageState build() {
    _$HomePageState _$result;
    try {
      _$result = _$v ??
          new _$HomePageState._(
              resultText: resultText,
              books: books.build(),
              isFirstPageLoading: isFirstPageLoading,
              loadFirstPageError: loadFirstPageError,
              isNextPageLoading: isNextPageLoading,
              loadNextPageError: loadNextPageError);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'books';
        books.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'HomePageState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
