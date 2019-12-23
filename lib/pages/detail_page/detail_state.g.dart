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
  @override
  final String description;
  @override
  final String publishedDate;

  factory _$BookDetailState([void Function(BookDetailStateBuilder) updates]) =>
      (new BookDetailStateBuilder()..update(updates)).build();

  _$BookDetailState._(
      {this.id,
      this.title,
      this.subtitle,
      this.authors,
      this.largeImage,
      this.thumbnail,
      this.isFavorited,
      this.description,
      this.publishedDate})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('BookDetailState', 'id');
    }
  }

  @override
  BookDetailState rebuild(void Function(BookDetailStateBuilder) updates) =>
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
        isFavorited == other.isFavorited &&
        description == other.description &&
        publishedDate == other.publishedDate;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, id.hashCode), title.hashCode),
                                subtitle.hashCode),
                            authors.hashCode),
                        largeImage.hashCode),
                    thumbnail.hashCode),
                isFavorited.hashCode),
            description.hashCode),
        publishedDate.hashCode));
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
          ..add('isFavorited', isFavorited)
          ..add('description', description)
          ..add('publishedDate', publishedDate))
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

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _publishedDate;
  String get publishedDate => _$this._publishedDate;
  set publishedDate(String publishedDate) =>
      _$this._publishedDate = publishedDate;

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
      _description = _$v.description;
      _publishedDate = _$v.publishedDate;
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
  void update(void Function(BookDetailStateBuilder) updates) {
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
              authors: _authors?.build(),
              largeImage: largeImage,
              thumbnail: thumbnail,
              isFavorited: isFavorited,
              description: description,
              publishedDate: publishedDate);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'authors';
        _authors?.build();
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
