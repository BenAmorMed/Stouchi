import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('server')
  server,
}
