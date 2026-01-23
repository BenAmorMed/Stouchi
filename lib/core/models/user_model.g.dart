// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      isFirstLogin: json['isFirstLogin'] as bool? ?? true,
      currentShiftId: json['currentShiftId'] as String?,
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
      baseSalary: (json['baseSalary'] as num?)?.toDouble() ?? 0.0,
      salaryType:
          $enumDecodeNullable(_$SalaryTypeEnumMap, json['salaryType']) ??
          SalaryType.hourly,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'isFirstLogin': instance.isFirstLogin,
      'currentShiftId': instance.currentShiftId,
      'hourlyRate': instance.hourlyRate,
      'baseSalary': instance.baseSalary,
      'salaryType': _$SalaryTypeEnumMap[instance.salaryType]!,
    };

const _$UserRoleEnumMap = {UserRole.admin: 'admin', UserRole.server: 'server'};

const _$SalaryTypeEnumMap = {
  SalaryType.hourly: 'hourly',
  SalaryType.fixed: 'fixed',
  SalaryType.both: 'both',
};
