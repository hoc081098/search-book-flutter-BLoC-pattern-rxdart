// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_books_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FavBooksState extends FavBooksState {
  @override
  final bool isLoading;
  @override
  final BuiltList<FavBookItem> books;

  factory _$FavBooksState([void Function(FavBooksStateBuilder) updates]) =>
      (new FavBooksStateBuilder()..update(updates)).build();

  _$FavBooksState._({this.isLoading, this.books}) : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('FavBooksState', 'isLoading');
    }
    if (books == null) {
      throw new BuiltValueNullFieldError('FavBooksState', 'books');
    }
  }

  @override
  FavBooksState rebuild(void Function(FavBooksStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavBooksStateBuilder toBuilder() => new FavBooksStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavBooksState &&
        isLoading == other.isLoading &&
        books == other.books;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, isLoading.hashCode), books.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FavBooksState')
          ..add('isLoading', isLoading)
          ..add('books', books))
        .toString();
  }
}

class FavBooksStateBuilder
    implements Builder<FavBooksState, FavBooksStateBuilder> {
  _$FavBooksState _$v;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  ListBuilder<FavBookItem> _books;
  ListBuilder<FavBookItem> get books =>
      _$this._books ??= new ListBuilder<FavBookItem>();
  set books(ListBuilder<FavBookItem> books) => _$this._books = books;

  FavBooksStateBuilder();

  FavBooksStateBuilder get _$this {
    if (_$v != null) {
      _isLoading = _$v.isLoading;
      _books = _$v.books?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FavBooksState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FavBooksState;
  }

  @override
  void update(void Function(FavBooksStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FavBooksState build() {
    _$FavBooksState _$result;
    try {
      _$result = _$v ??
          new _$FavBooksState._(isLoading: isLoading, books: books.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'books';
        books.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FavBooksState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$FavBookItem extends FavBookItem {
  @override
  final bool isLoading;
  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String thumbnail;

  factory _$FavBookItem([void Function(FavBookItemBuilder) updates]) =>
      (new FavBookItemBuilder()..update(updates)).build();

  _$FavBookItem._(
      {this.isLoading, this.id, this.title, this.subtitle, this.thumbnail})
      : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('FavBookItem', 'isLoading');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('FavBookItem', 'id');
    }
  }

  @override
  FavBookItem rebuild(void Function(FavBookItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavBookItemBuilder toBuilder() => new FavBookItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavBookItem &&
        isLoading == other.isLoading &&
        id == other.id &&
        title == other.title &&
        subtitle == other.subtitle &&
        thumbnail == other.thumbnail;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, isLoading.hashCode), id.hashCode), title.hashCode),
            subtitle.hashCode),
        thumbnail.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FavBookItem')
          ..add('isLoading', isLoading)
          ..add('id', id)
          ..add('title', title)
          ..add('subtitle', subtitle)
          ..add('thumbnail', thumbnail))
        .toString();
  }
}

class FavBookItemBuilder implements Builder<FavBookItem, FavBookItemBuilder> {
  _$FavBookItem _$v;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

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

  FavBookItemBuilder();

  FavBookItemBuilder get _$this {
    if (_$v != null) {
      _isLoading = _$v.isLoading;
      _id = _$v.id;
      _title = _$v.title;
      _subtitle = _$v.subtitle;
      _thumbnail = _$v.thumbnail;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FavBookItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FavBookItem;
  }

  @override
  void update(void Function(FavBookItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FavBookItem build() {
    final _$result = _$v ??
        new _$FavBookItem._(
            isLoading: isLoading,
            id: id,
            title: title,
            subtitle: subtitle,
            thumbnail: thumbnail);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
