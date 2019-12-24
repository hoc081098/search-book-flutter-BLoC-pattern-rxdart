// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_fav_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ToggleFavResult extends ToggleFavResult {
  @override
  final String id;
  @override
  final bool added;
  @override
  final bool result;
  @override
  final Object error;

  factory _$ToggleFavResult([void Function(ToggleFavResultBuilder) updates]) =>
      (new ToggleFavResultBuilder()..update(updates)).build();

  _$ToggleFavResult._({this.id, this.added, this.result, this.error})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('ToggleFavResult', 'id');
    }
    if (added == null) {
      throw new BuiltValueNullFieldError('ToggleFavResult', 'added');
    }
  }

  @override
  ToggleFavResult rebuild(void Function(ToggleFavResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ToggleFavResultBuilder toBuilder() =>
      new ToggleFavResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ToggleFavResult &&
        id == other.id &&
        added == other.added &&
        result == other.result &&
        error == other.error;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, id.hashCode), added.hashCode), result.hashCode),
        error.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ToggleFavResult')
          ..add('id', id)
          ..add('added', added)
          ..add('result', result)
          ..add('error', error))
        .toString();
  }
}

class ToggleFavResultBuilder
    implements Builder<ToggleFavResult, ToggleFavResultBuilder> {
  _$ToggleFavResult _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  bool _added;
  bool get added => _$this._added;
  set added(bool added) => _$this._added = added;

  bool _result;
  bool get result => _$this._result;
  set result(bool result) => _$this._result = result;

  Object _error;
  Object get error => _$this._error;
  set error(Object error) => _$this._error = error;

  ToggleFavResultBuilder();

  ToggleFavResultBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _added = _$v.added;
      _result = _$v.result;
      _error = _$v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ToggleFavResult other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ToggleFavResult;
  }

  @override
  void update(void Function(ToggleFavResultBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ToggleFavResult build() {
    final _$result = _$v ??
        new _$ToggleFavResult._(
            id: id, added: added, result: result, error: error);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
