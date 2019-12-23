import 'package:built_value/built_value.dart';

class CustomBuiltValueToStringHelper implements BuiltValueToStringHelper {
  StringBuffer _result = StringBuffer();
  bool _previousField = false;

  CustomBuiltValueToStringHelper(String className) {
    _result..write(className)..write(' {');
  }

  @override
  void add(String field, Object value) {
    if (value != null) {
      if (_previousField) _result.write(',');
      _result
        ..write(field + (value is Iterable ? '.length' : ''))
        ..write('=')
        ..write(value is Iterable ? value.length : value);
      _previousField = true;
    }
  }

  @override
  String toString() {
    _result..write('}');
    final stringResult = _result.toString();
    _result = null;
    return stringResult;
  }
}
