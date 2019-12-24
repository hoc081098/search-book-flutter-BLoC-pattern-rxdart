import 'package:built_value/built_value.dart';

part 'toggle_fav_result.g.dart';

abstract class ToggleFavResult
    implements Built<ToggleFavResult, ToggleFavResultBuilder> {
  String get id;

  bool get added;

  @nullable
  bool get result;

  @nullable
  Object get error;

  ToggleFavResult._();

  factory ToggleFavResult([void Function(ToggleFavResultBuilder) updates]) =
      _$ToggleFavResult;
}
