import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User(
      {required String? userId,
      required String? username,
      required String? password,
      required String? companyId,
      required String? token}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
