//accesstoken, refreshtoken

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
class Auth with _$Auth {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Auth({
    required String accessToken,
    required String refreshToken,
  }) = _Auth;

  factory Auth.fromJson(Map<String, Object?> json) => _$AuthFromJson(json);
}
