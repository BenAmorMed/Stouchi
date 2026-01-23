// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  String get articleId => throw _privateConstructorUsedError;
  String get articleName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get quantity =>
      throw _privateConstructorUsedError; // Changed from int to double
  double get costPrice =>
      throw _privateConstructorUsedError; // For profit calculation (FIFO based)
  List<String> get comments =>
      throw _privateConstructorUsedError; // Global comments applied to all units
  Map<int, List<String>> get perUnitComments =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
    OrderItemModel value,
    $Res Function(OrderItemModel) then,
  ) = _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call({
    String articleId,
    String articleName,
    double price,
    double quantity,
    double costPrice,
    List<String> comments,
    Map<int, List<String>> perUnitComments,
  });
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articleId = null,
    Object? articleName = null,
    Object? price = null,
    Object? quantity = null,
    Object? costPrice = null,
    Object? comments = null,
    Object? perUnitComments = null,
  }) {
    return _then(
      _value.copyWith(
            articleId: null == articleId
                ? _value.articleId
                : articleId // ignore: cast_nullable_to_non_nullable
                      as String,
            articleName: null == articleName
                ? _value.articleName
                : articleName // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            costPrice: null == costPrice
                ? _value.costPrice
                : costPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            comments: null == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            perUnitComments: null == perUnitComments
                ? _value.perUnitComments
                : perUnitComments // ignore: cast_nullable_to_non_nullable
                      as Map<int, List<String>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(
    _$OrderItemModelImpl value,
    $Res Function(_$OrderItemModelImpl) then,
  ) = __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String articleId,
    String articleName,
    double price,
    double quantity,
    double costPrice,
    List<String> comments,
    Map<int, List<String>> perUnitComments,
  });
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
    _$OrderItemModelImpl _value,
    $Res Function(_$OrderItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? articleId = null,
    Object? articleName = null,
    Object? price = null,
    Object? quantity = null,
    Object? costPrice = null,
    Object? comments = null,
    Object? perUnitComments = null,
  }) {
    return _then(
      _$OrderItemModelImpl(
        articleId: null == articleId
            ? _value.articleId
            : articleId // ignore: cast_nullable_to_non_nullable
                  as String,
        articleName: null == articleName
            ? _value.articleName
            : articleName // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        costPrice: null == costPrice
            ? _value.costPrice
            : costPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        comments: null == comments
            ? _value._comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        perUnitComments: null == perUnitComments
            ? _value._perUnitComments
            : perUnitComments // ignore: cast_nullable_to_non_nullable
                  as Map<int, List<String>>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemModelImpl implements _OrderItemModel {
  const _$OrderItemModelImpl({
    required this.articleId,
    required this.articleName,
    required this.price,
    this.quantity = 1.0,
    this.costPrice = 0.0,
    final List<String> comments = const [],
    final Map<int, List<String>> perUnitComments = const {},
  }) : _comments = comments,
       _perUnitComments = perUnitComments;

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  final String articleId;
  @override
  final String articleName;
  @override
  final double price;
  @override
  @JsonKey()
  final double quantity;
  // Changed from int to double
  @override
  @JsonKey()
  final double costPrice;
  // For profit calculation (FIFO based)
  final List<String> _comments;
  // For profit calculation (FIFO based)
  @override
  @JsonKey()
  List<String> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  // Global comments applied to all units
  final Map<int, List<String>> _perUnitComments;
  // Global comments applied to all units
  @override
  @JsonKey()
  Map<int, List<String>> get perUnitComments {
    if (_perUnitComments is EqualUnmodifiableMapView) return _perUnitComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_perUnitComments);
  }

  @override
  String toString() {
    return 'OrderItemModel(articleId: $articleId, articleName: $articleName, price: $price, quantity: $quantity, costPrice: $costPrice, comments: $comments, perUnitComments: $perUnitComments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.articleId, articleId) ||
                other.articleId == articleId) &&
            (identical(other.articleName, articleName) ||
                other.articleName == articleName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.costPrice, costPrice) ||
                other.costPrice == costPrice) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            const DeepCollectionEquality().equals(
              other._perUnitComments,
              _perUnitComments,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    articleId,
    articleName,
    price,
    quantity,
    costPrice,
    const DeepCollectionEquality().hash(_comments),
    const DeepCollectionEquality().hash(_perUnitComments),
  );

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(this);
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  const factory _OrderItemModel({
    required final String articleId,
    required final String articleName,
    required final double price,
    final double quantity,
    final double costPrice,
    final List<String> comments,
    final Map<int, List<String>> perUnitComments,
  }) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  String get articleId;
  @override
  String get articleName;
  @override
  double get price;
  @override
  double get quantity; // Changed from int to double
  @override
  double get costPrice; // For profit calculation (FIFO based)
  @override
  List<String> get comments; // Global comments applied to all units
  @override
  Map<int, List<String>> get perUnitComments;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
