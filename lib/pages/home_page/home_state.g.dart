// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HomePageState extends HomePageState {
  @override
  final String resultText;
  @override
  final BuiltList<Book> books;
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
    if (loadFirstPageError == null) {
      throw new BuiltValueNullFieldError('HomePageState', 'loadFirstPageError');
    }
    if (isNextPageLoading == null) {
      throw new BuiltValueNullFieldError('HomePageState', 'isNextPageLoading');
    }
    if (loadNextPageError == null) {
      throw new BuiltValueNullFieldError('HomePageState', 'loadNextPageError');
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

  ListBuilder<Book> _books;
  ListBuilder<Book> get books => _$this._books ??= new ListBuilder<Book>();
  set books(ListBuilder<Book> books) => _$this._books = books;

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
