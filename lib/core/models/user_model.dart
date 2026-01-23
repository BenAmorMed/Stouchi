import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum SalaryType { hourly, fixed, both }

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required UserRole role,
    @Default(true) bool isFirstLogin,
    String? currentShiftId,
    @Default(0.0) double hourlyRate,
    @Default(0.0) double baseSalary,
    @Default(SalaryType.hourly) SalaryType salaryType,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
