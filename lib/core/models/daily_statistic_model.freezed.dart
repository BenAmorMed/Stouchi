// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_statistic_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ArticleDailyStats _$ArticleDailyStatsFromJson(Map<String, dynamic> json) {
  return _ArticleDailyStats.fromJson(json);
}

/// @nodoc
mixin _$ArticleDailyStats {
  String get name => throw _privateConstructorUsedError;
  double get qty => throw _privateConstructorUsedError;
  double get revenue => throw _privateConstructorUsedError;
  double get profit => throw _privateConstructorUsedError;

  /// Serializes this ArticleDailyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArticleDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleDailyStatsCopyWith<ArticleDailyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleDailyStatsCopyWith<$Res> {
  factory $ArticleDailyStatsCopyWith(
    ArticleDailyStats value,
    $Res Function(ArticleDailyStats) then,
  ) = _$ArticleDailyStatsCopyWithImpl<$Res, ArticleDailyStats>;
  @useResult
  $Res call({String name, double qty, double revenue, double profit});
}

/// @nodoc
class _$ArticleDailyStatsCopyWithImpl<$Res, $Val extends ArticleDailyStats>
    implements $ArticleDailyStatsCopyWith<$Res> {
  _$ArticleDailyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArticleDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? qty = null,
    Object? revenue = null,
    Object? profit = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            qty: null == qty
                ? _value.qty
                : qty // ignore: cast_nullable_to_non_nullable
                      as double,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as double,
            profit: null == profit
                ? _value.profit
                : profit // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleDailyStatsImplCopyWith<$Res>
    implements $ArticleDailyStatsCopyWith<$Res> {
  factory _$$ArticleDailyStatsImplCopyWith(
    _$ArticleDailyStatsImpl value,
    $Res Function(_$ArticleDailyStatsImpl) then,
  ) = __$$ArticleDailyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double qty, double revenue, double profit});
}

/// @nodoc
class __$$ArticleDailyStatsImplCopyWithImpl<$Res>
    extends _$ArticleDailyStatsCopyWithImpl<$Res, _$ArticleDailyStatsImpl>
    implements _$$ArticleDailyStatsImplCopyWith<$Res> {
  __$$ArticleDailyStatsImplCopyWithImpl(
    _$ArticleDailyStatsImpl _value,
    $Res Function(_$ArticleDailyStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArticleDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? qty = null,
    Object? revenue = null,
    Object? profit = null,
  }) {
    return _then(
      _$ArticleDailyStatsImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        qty: null == qty
            ? _value.qty
            : qty // ignore: cast_nullable_to_non_nullable
                  as double,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as double,
        profit: null == profit
            ? _value.profit
            : profit // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleDailyStatsImpl implements _ArticleDailyStats {
  const _$ArticleDailyStatsImpl({
    required this.name,
    this.qty = 0.0,
    this.revenue = 0.0,
    this.profit = 0.0,
  });

  factory _$ArticleDailyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleDailyStatsImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final double qty;
  @override
  @JsonKey()
  final double revenue;
  @override
  @JsonKey()
  final double profit;

  @override
  String toString() {
    return 'ArticleDailyStats(name: $name, qty: $qty, revenue: $revenue, profit: $profit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleDailyStatsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.revenue, revenue) || other.revenue == revenue) &&
            (identical(other.profit, profit) || other.profit == profit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, qty, revenue, profit);

  /// Create a copy of ArticleDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleDailyStatsImplCopyWith<_$ArticleDailyStatsImpl> get copyWith =>
      __$$ArticleDailyStatsImplCopyWithImpl<_$ArticleDailyStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleDailyStatsImplToJson(this);
  }
}

abstract class _ArticleDailyStats implements ArticleDailyStats {
  const factory _ArticleDailyStats({
    required final String name,
    final double qty,
    final double revenue,
    final double profit,
  }) = _$ArticleDailyStatsImpl;

  factory _ArticleDailyStats.fromJson(Map<String, dynamic> json) =
      _$ArticleDailyStatsImpl.fromJson;

  @override
  String get name;
  @override
  double get qty;
  @override
  double get revenue;
  @override
  double get profit;

  /// Create a copy of ArticleDailyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleDailyStatsImplCopyWith<_$ArticleDailyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyStatisticModel _$DailyStatisticModelFromJson(Map<String, dynamic> json) {
  return _DailyStatisticModel.fromJson(json);
}

/// @nodoc
mixin _$DailyStatisticModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  double get sales => throw _privateConstructorUsedError;
  double get tips => throw _privateConstructorUsedError;
  double get profit => throw _privateConstructorUsedError;
  int get orderCount => throw _privateConstructorUsedError;
  Map<String, ArticleDailyStats> get articleStats =>
      throw _privateConstructorUsedError;

  /// Serializes this DailyStatisticModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyStatisticModelCopyWith<DailyStatisticModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyStatisticModelCopyWith<$Res> {
  factory $DailyStatisticModelCopyWith(
    DailyStatisticModel value,
    $Res Function(DailyStatisticModel) then,
  ) = _$DailyStatisticModelCopyWithImpl<$Res, DailyStatisticModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    @TimestampConverter() DateTime date,
    double sales,
    double tips,
    double profit,
    int orderCount,
    Map<String, ArticleDailyStats> articleStats,
  });
}

/// @nodoc
class _$DailyStatisticModelCopyWithImpl<$Res, $Val extends DailyStatisticModel>
    implements $DailyStatisticModelCopyWith<$Res> {
  _$DailyStatisticModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? sales = null,
    Object? tips = null,
    Object? profit = null,
    Object? orderCount = null,
    Object? articleStats = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sales: null == sales
                ? _value.sales
                : sales // ignore: cast_nullable_to_non_nullable
                      as double,
            tips: null == tips
                ? _value.tips
                : tips // ignore: cast_nullable_to_non_nullable
                      as double,
            profit: null == profit
                ? _value.profit
                : profit // ignore: cast_nullable_to_non_nullable
                      as double,
            orderCount: null == orderCount
                ? _value.orderCount
                : orderCount // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$DailyStatisticModelImplCopyWith<$Res>
    implements $DailyStatisticModelCopyWith<$Res> {
  factory _$$DailyStatisticModelImplCopyWith(
    _$DailyStatisticModelImpl value,
    $Res Function(_$DailyStatisticModelImpl) then,
  ) = __$$DailyStatisticModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    @TimestampConverter() DateTime date,
    double sales,
    double tips,
    double profit,
    int orderCount,
    Map<String, ArticleDailyStats> articleStats,
  });
}

/// @nodoc
class __$$DailyStatisticModelImplCopyWithImpl<$Res>
    extends _$DailyStatisticModelCopyWithImpl<$Res, _$DailyStatisticModelImpl>
    implements _$$DailyStatisticModelImplCopyWith<$Res> {
  __$$DailyStatisticModelImplCopyWithImpl(
    _$DailyStatisticModelImpl _value,
    $Res Function(_$DailyStatisticModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? sales = null,
    Object? tips = null,
    Object? profit = null,
    Object? orderCount = null,
    Object? articleStats = null,
  }) {
    return _then(
      _$DailyStatisticModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sales: null == sales
            ? _value.sales
            : sales // ignore: cast_nullable_to_non_nullable
                  as double,
        tips: null == tips
            ? _value.tips
            : tips // ignore: cast_nullable_to_non_nullable
                  as double,
        profit: null == profit
            ? _value.profit
            : profit // ignore: cast_nullable_to_non_nullable
                  as double,
        orderCount: null == orderCount
            ? _value.orderCount
            : orderCount // ignore: cast_nullable_to_non_nullable
                  as int,
        articleStats: null == articleStats
            ? _value._articleStats
            : articleStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, ArticleDailyStats>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyStatisticModelImpl implements _DailyStatisticModel {
  const _$DailyStatisticModelImpl({
    required this.id,
    required this.userId,
    @TimestampConverter() required this.date,
    this.sales = 0.0,
    this.tips = 0.0,
    this.profit = 0.0,
    this.orderCount = 0,
    final Map<String, ArticleDailyStats> articleStats = const {},
  }) : _articleStats = articleStats;

  factory _$DailyStatisticModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyStatisticModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  @TimestampConverter()
  final DateTime date;
  @override
  @JsonKey()
  final double sales;
  @override
  @JsonKey()
  final double tips;
  @override
  @JsonKey()
  final double profit;
  @override
  @JsonKey()
  final int orderCount;
  final Map<String, ArticleDailyStats> _articleStats;
  @override
  @JsonKey()
  Map<String, ArticleDailyStats> get articleStats {
    if (_articleStats is EqualUnmodifiableMapView) return _articleStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_articleStats);
  }

  @override
  String toString() {
    return 'DailyStatisticModel(id: $id, userId: $userId, date: $date, sales: $sales, tips: $tips, profit: $profit, orderCount: $orderCount, articleStats: $articleStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyStatisticModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.sales, sales) || other.sales == sales) &&
            (identical(other.tips, tips) || other.tips == tips) &&
            (identical(other.profit, profit) || other.profit == profit) &&
            (identical(other.orderCount, orderCount) ||
                other.orderCount == orderCount) &&
            const DeepCollectionEquality().equals(
              other._articleStats,
              _articleStats,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    date,
    sales,
    tips,
    profit,
    orderCount,
    const DeepCollectionEquality().hash(_articleStats),
  );

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyStatisticModelImplCopyWith<_$DailyStatisticModelImpl> get copyWith =>
      __$$DailyStatisticModelImplCopyWithImpl<_$DailyStatisticModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyStatisticModelImplToJson(this);
  }
}

abstract class _DailyStatisticModel implements DailyStatisticModel {
  const factory _DailyStatisticModel({
    required final String id,
    required final String userId,
    @TimestampConverter() required final DateTime date,
    final double sales,
    final double tips,
    final double profit,
    final int orderCount,
    final Map<String, ArticleDailyStats> articleStats,
  }) = _$DailyStatisticModelImpl;

  factory _DailyStatisticModel.fromJson(Map<String, dynamic> json) =
      _$DailyStatisticModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  @TimestampConverter()
  DateTime get date;
  @override
  double get sales;
  @override
  double get tips;
  @override
  double get profit;
  @override
  int get orderCount;
  @override
  Map<String, ArticleDailyStats> get articleStats;

  /// Create a copy of DailyStatisticModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyStatisticModelImplCopyWith<_$DailyStatisticModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
