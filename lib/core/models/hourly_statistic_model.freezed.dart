// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hourly_statistic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HourlyStatistic {
  int get hour => throw _privateConstructorUsedError; // 0-23
  double get sales => throw _privateConstructorUsedError;
  double get profit => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;
  Map<String, double> get userSales =>
      throw _privateConstructorUsedError; // UserId -> Sales
  Map<String, double> get userProfit =>
      throw _privateConstructorUsedError; // UserId -> Profit
  Map<String, ArticleDailyStats> get articleStats =>
      throw _privateConstructorUsedError;

  /// Create a copy of HourlyStatistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HourlyStatisticCopyWith<HourlyStatistic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HourlyStatisticCopyWith<$Res> {
  factory $HourlyStatisticCopyWith(
    HourlyStatistic value,
    $Res Function(HourlyStatistic) then,
  ) = _$HourlyStatisticCopyWithImpl<$Res, HourlyStatistic>;
  @useResult
  $Res call({
    int hour,
    double sales,
    double profit,
    int orderCount,
    Map<String, double> userSales,
    Map<String, double> userProfit,
    Map<String, ArticleDailyStats> articleStats,
  });
}

/// @nodoc
class _$HourlyStatisticCopyWithImpl<$Res, $Val extends HourlyStatistic>
    implements $HourlyStatisticCopyWith<$Res> {
  _$HourlyStatisticCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HourlyStatistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? sales = null,
    Object? profit = null,
    Object? orderCount = null,
    Object? userSales = null,
    Object? userProfit = null,
    Object? articleStats = null,
  }) {
    return _then(
      _value.copyWith(
            hour: null == hour
                ? _value.hour
                : hour // ignore: cast_nullable_to_non_nullable
                      as int,
            sales: null == sales
                ? _value.sales
                : sales // ignore: cast_nullable_to_non_nullable
                      as double,
            profit: null == profit
                ? _value.profit
                : profit // ignore: cast_nullable_to_non_nullable
                      as double,
            orderCount: null == orderCount
                ? _value.orderCount
                : orderCount // ignore: cast_nullable_to_non_nullable
                      as int,
            userSales: null == userSales
                ? _value.userSales
                : userSales // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            userProfit: null == userProfit
                ? _value.userProfit
                : userProfit // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            articleStats: null == articleStats
                ? _value.articleStats
                : articleStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, ArticleDailyStats>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HourlyStatisticImplCopyWith<$Res>
    implements $HourlyStatisticCopyWith<$Res> {
  factory _$$HourlyStatisticImplCopyWith(
    _$HourlyStatisticImpl value,
    $Res Function(_$HourlyStatisticImpl) then,
  ) = __$$HourlyStatisticImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int hour,
    double sales,
    double profit,
    int orderCount,
    Map<String, double> userSales,
    Map<String, double> userProfit,
    Map<String, ArticleDailyStats> articleStats,
  });
}

/// @nodoc
class __$$HourlyStatisticImplCopyWithImpl<$Res>
    extends _$HourlyStatisticCopyWithImpl<$Res, _$HourlyStatisticImpl>
    implements _$$HourlyStatisticImplCopyWith<$Res> {
  __$$HourlyStatisticImplCopyWithImpl(
    _$HourlyStatisticImpl _value,
    $Res Function(_$HourlyStatisticImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HourlyStatistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hour = null,
    Object? sales = null,
    Object? profit = null,
    Object? orderCount = null,
    Object? userSales = null,
    Object? userProfit = null,
    Object? articleStats = null,
  }) {
    return _then(
      _$HourlyStatisticImpl(
        hour: null == hour
            ? _value.hour
            : hour // ignore: cast_nullable_to_non_nullable
                  as int,
        sales: null == sales
            ? _value.sales
            : sales // ignore: cast_nullable_to_non_nullable
                  as double,
        profit: null == profit
            ? _value.profit
            : profit // ignore: cast_nullable_to_non_nullable
                  as double,
        orderCount: null == orderCount
            ? _value.orderCount
            : orderCount // ignore: cast_nullable_to_non_nullable
                  as int,
        userSales: null == userSales
            ? _value._userSales
            : userSales // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        userProfit: null == userProfit
            ? _value._userProfit
            : userProfit // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        articleStats: null == articleStats
            ? _value._articleStats
            : articleStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, ArticleDailyStats>,
      ),
    );
  }
}

/// @nodoc

class _$HourlyStatisticImpl implements _HourlyStatistic {
  const _$HourlyStatisticImpl({
    required this.hour,
    this.sales = 0.0,
    this.profit = 0.0,
    this.orderCount = 0,
    final Map<String, double> userSales = const {},
    final Map<String, double> userProfit = const {},
    final Map<String, ArticleDailyStats> articleStats = const {},
  }) : _userSales = userSales,
       _userProfit = userProfit,
       _articleStats = articleStats;

  @override
  final int hour;
  // 0-23
  @override
  @JsonKey()
  final double sales;
  @override
  @JsonKey()
  final double profit;
  @override
  @JsonKey()
  final int orderCount;
  final Map<String, double> _userSales;
  @override
  @JsonKey()
  Map<String, double> get userSales {
    if (_userSales is EqualUnmodifiableMapView) return _userSales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userSales);
  }

  // UserId -> Sales
  final Map<String, double> _userProfit;
  // UserId -> Sales
  @override
  @JsonKey()
  Map<String, double> get userProfit {
    if (_userProfit is EqualUnmodifiableMapView) return _userProfit;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userProfit);
  }

  // UserId -> Profit
  final Map<String, ArticleDailyStats> _articleStats;
  // UserId -> Profit
  @override
  @JsonKey()
  Map<String, ArticleDailyStats> get articleStats {
    if (_articleStats is EqualUnmodifiableMapView) return _articleStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_articleStats);
  }

  @override
  String toString() {
    return 'HourlyStatistic(hour: $hour, sales: $sales, profit: $profit, orderCount: $orderCount, userSales: $userSales, userProfit: $userProfit, articleStats: $articleStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HourlyStatisticImpl &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.sales, sales) || other.sales == sales) &&
            (identical(other.profit, profit) || other.profit == profit) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            const DeepCollectionEquality().equals(
              other._userSales,
              _userSales,
            ) &&
            const DeepCollectionEquality().equals(
              other._userProfit,
              _userProfit,
            ) &&
            const DeepCollectionEquality().equals(
              other._articleStats,
              _articleStats,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    hour,
    sales,
    profit,
    orderCount,
    const DeepCollectionEquality().hash(_userSales),
    const DeepCollectionEquality().hash(_userProfit),
    const DeepCollectionEquality().hash(_articleStats),
  );

  /// Create a copy of HourlyStatistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HourlyStatisticImplCopyWith<_$HourlyStatisticImpl> get copyWith =>
      __$$HourlyStatisticImplCopyWithImpl<_$HourlyStatisticImpl>(
        this,
        _$identity,
      );
}

abstract class _HourlyStatistic implements HourlyStatistic {
  const factory _HourlyStatistic({
    required final int hour,
    final double sales,
    final double profit,
    final int orderCount,
    final Map<String, double> userSales,
    final Map<String, double> userProfit,
    final Map<String, ArticleDailyStats> articleStats,
  }) = _$HourlyStatisticImpl;

  @override
  int get hour; // 0-23
  @override
  double get sales;
  @override
  double get profit;
  @override
  int get orderCount;
  @override
  Map<String, double> get userSales; // UserId -> Sales
  @override
  Map<String, double> get userProfit; // UserId -> Profit
  @override
  Map<String, ArticleDailyStats> get articleStats;

  /// Create a copy of HourlyStatistic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HourlyStatisticImplCopyWith<_$HourlyStatisticImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
