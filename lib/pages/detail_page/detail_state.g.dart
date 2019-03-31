// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookDetailState extends BookDetailState {
  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final BuiltList<String> authors;
  @override
  final String largeImage;
  @override
  final String thumbnail;
  @override
  final bool isFavorited;

  factory _$BookDetailState([void updates(BookDetailStateBuilder b)]) =>
      (new BookDetailStateBuilder()..update(updates)).build();

  _$BookDetailState._(
      {this.id,
      this.title,
      this.subtitle,
      this.authors,
      this.largeImage,
      this.thumbnail,
      this.isFavorited})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'id');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'title');
    }
    if (subtitle == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'subtitle');
    }
    if (authors == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'authors');
    }
    if (largeImage == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'largeImage');
    }
    if (thumbnail == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'thumbnail');
    }
    if (isFavorited == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'isFavorited');
    }
  }

  @override
  BookDetailState rebuild(void updates(BookDetailStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  BookDetailStateBuilder toBuilder() =>
      new BookDetailStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookDetailState &&
        id == other.id &&
        title == other.title &&
        subtitle == other.subtitle &&
        authors == other.authors &&
        largeImage == other.largeImage &&
        thumbnail == other.thumbnail &&
        isFavorited == other.isFavorited;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), title.hashCode),
                        subtitle.hashCode),
                    authors.hashCode),
                largeImage.hashCode),
            thumbnail.hashCode),
        isFavorited.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BookDetailState')
          ..add('id', id)
          ..add('title', title)
          ..add('subtitle', subtitle)
          ..add('authors', authors)
          ..add('largeImage', largeImage)
          ..add('thumbnail', thumbnail)
          ..add('isFavorited', isFavorited))
        .toString();
  }
}

class BookDetailStateBuilder
    implements Builder<BookDetailState, BookDetailStateBuilder> {
  _$BookDetailState _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _subtitle;
  String get subtitle => _$this._subtitle;
  set subtitle(String subtitle) => _$this._subtitle = subtitle;

  ListBuilder<String> _authors;
  ListBuilder<String> get authors =>
      _$this._authors ??= new ListBuilder<String>();
  set authors(ListBuilder<String> authors) => _$this._authors = authors;

  String _largeImage;
  String get largeImage => _$this._largeImage;
  set largeImage(String largeImage) => _$this._largeImage = largeImage;

  String _thumbnail;
  String get thumbnail => _$this._thumbnail;
  set thumbnail(String thumbnail) => _$this._thumbnail = thumbnail;

  bool _isFavorited;
  bool get isFavorited => _$this._isFavorited;
  set isFavorited(bool isFavorited) => _$this._isFavorited = isFavorited;

  BookDetailStateBuilder();

  BookDetailStateBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _title = _$v.title;
      _subtitle = _$v.subtitle;
      _authors = _$v.authors?.toBuilder();
      _largeImage = _$v.largeImage;
      _thumbnail = _$v.thumbnail;
      _isFavorited = _$v.isFavorited;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookDetailState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BookDetailState;
  }

  @override
  void update(void updates(BookDetailStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$BookDetailState build() {
    _$BookDetailState _$result;
    try {
      _$result = _$v ??
          new _$BookDetailState._(
              id: id,
              title: title,
              subtitle: subtitle,
              authors: authors.build(),
              largeImage: largeImage,
              thumbnail: thumbnail,
              isFavorited: isFavorited);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'authors';
        authors.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BookDetailState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
