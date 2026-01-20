// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) {
  return _ArticleModel.fromJson(json);
}

/// @nodoc
mixin _$ArticleModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  CommentConfig get commentConfig => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  double get totalProfit =>
      throw _privateConstructorUsedError; // Lifetime profit from sales
  bool get isComposite =>
      throw _privateConstructorUsedError; // true if it has multiple ingredients
  List<RecipeIngredient> get recipe => throw _privateConstructorUsedError;

  /// Serializes this ArticleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleModelCopyWith<ArticleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleModelCopyWith<$Res> {
  factory $ArticleModelCopyWith(
    ArticleModel value,
    $Res Function(ArticleModel) then,
  ) = _$ArticleModelCopyWithImpl<$Res, ArticleModel>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    String categoryId,
    CommentConfig commentConfig,
    String? imageUrl,
    double totalProfit,
    bool isComposite,
    List<RecipeIngredient> recipe,
  });

  $CommentConfigCopyWith<$Res> get commentConfig;
}

/// @nodoc
class _$ArticleModelCopyWithImpl<$Res, $Val extends ArticleModel>
    implements $ArticleModelCopyWith<$Res> {
  _$ArticleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? categoryId = null,
    Object? commentConfig = null,
    Object? imageUrl = freezed,
    Object? totalProfit = null,
    Object? isComposite = null,
    Object? recipe = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            commentConfig: null == commentConfig
                ? _value.commentConfig
                : commentConfig // ignore: cast_nullable_to_non_nullable
                      as CommentConfig,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalProfit: null == totalProfit
                ? _value.totalProfit
                : totalProfit // ignore: cast_nullable_to_non_nullable
                      as double,
            isComposite: null == isComposite
                ? _value.isComposite
                : isComposite // ignore: cast_nullable_to_non_nullable
                      as bool,
            recipe: null == recipe
                ? _value.recipe
                : recipe // ignore: cast_nullable_to_non_nullable
                      as List<RecipeIngredient>,
          )
          as $Val,
    );
  }

  /// Create a copy of ArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommentConfigCopyWith<$Res> get commentConfig {
    return $CommentConfigCopyWith<$Res>(_value.commentConfig, (value) {
      return _then(_value.copyWith(commentConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ArticleModelImplCopyWith<$Res>
    implements $ArticleModelCopyWith<$Res> {
  factory _$$ArticleModelImplCopyWith(
    _$ArticleModelImpl value,
    $Res Function(_$ArticleModelImpl) then,
  ) = __$$ArticleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    String categoryId,
    CommentConfig commentConfig,
    String? imageUrl,
    double totalProfit,
    bool isComposite,
    List<RecipeIngredient> recipe,
  });

  @override
  $CommentConfigCopyWith<$Res> get commentConfig;
}

/// @nodoc
class __$$ArticleModelImplCopyWithImpl<$Res>
    extends _$ArticleModelCopyWithImpl<$Res, _$ArticleModelImpl>
    implements _$$ArticleModelImplCopyWith<$Res> {
  __$$ArticleModelImplCopyWithImpl(
    _$ArticleModelImpl _value,
    $Res Function(_$ArticleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? categoryId = null,
    Object? commentConfig = null,
    Object? imageUrl = freezed,
    Object? totalProfit = null,
    Object? isComposite = null,
    Object? recipe = null,
  }) {
    return _then(
      _$ArticleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        commentConfig: null == commentConfig
            ? _value.commentConfig
            : commentConfig // ignore: cast_nullable_to_non_nullable
                  as CommentConfig,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalProfit: null == totalProfit
            ? _value.totalProfit
            : totalProfit // ignore: cast_nullable_to_non_nullable
                  as double,
        isComposite: null == isComposite
            ? _value.isComposite
            : isComposite // ignore: cast_nullable_to_non_nullable
                  as bool,
        recipe: null == recipe
            ? _value._recipe
            : recipe // ignore: cast_nullable_to_non_nullable
                  as List<RecipeIngredient>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleModelImpl implements _ArticleModel {
  const _$ArticleModelImpl({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.commentConfig = const CommentConfig(),
    this.imageUrl,
    this.totalProfit = 0.0,
    this.isComposite = false,
    final List<RecipeIngredient> recipe = const [],
  }) : _recipe = recipe;

  factory _$ArticleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final String categoryId;
  @override
  @JsonKey()
  final CommentConfig commentConfig;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final double totalProfit;
  // Lifetime profit from sales
  @override
  @JsonKey()
  final bool isComposite;
  // true if it has multiple ingredients
  final List<RecipeIngredient> _recipe;
  // true if it has multiple ingredients
  @override
  @JsonKey()
  List<RecipeIngredient> get recipe {
    if (_recipe is EqualUnmodifiableListView) return _recipe;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipe);
  }

  @override
  String toString() {
    return 'ArticleModel(id: $id, name: $name, price: $price, categoryId: $categoryId, commentConfig: $commentConfig, imageUrl: $imageUrl, totalProfit: $totalProfit, isComposite: $isComposite, recipe: $recipe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.commentConfig, commentConfig) ||
                other.commentConfig == commentConfig) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            (identical(other.isComposite, isComposite) ||
                other.isComposite == isComposite) &&
            const DeepCollectionEquality().equals(other._recipe, _recipe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    categoryId,
    commentConfig,
    imageUrl,
    totalProfit,
    isComposite,
    const DeepCollectionEquality().hash(_recipe),
  );

  /// Create a copy of ArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleModelImplCopyWith<_$ArticleModelImpl> get copyWith =>
      __$$ArticleModelImplCopyWithImpl<_$ArticleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleModelImplToJson(this);
  }
}

abstract class _ArticleModel implements ArticleModel {
  const factory _ArticleModel({
    required final String id,
    required final String name,
    required final double price,
    required final String categoryId,
    final CommentConfig commentConfig,
    final String? imageUrl,
    final double totalProfit,
    final bool isComposite,
    final List<RecipeIngredient> recipe,
  }) = _$ArticleModelImpl;

  factory _ArticleModel.fromJson(Map<String, dynamic> json) =
      _$ArticleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  String get categoryId;
  @override
  CommentConfig get commentConfig;
  @override
  String? get imageUrl;
  @override
  double get totalProfit; // Lifetime profit from sales
  @override
  bool get isComposite; // true if it has multiple ingredients
  @override
  List<RecipeIngredient> get recipe;

  /// Create a copy of ArticleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleModelImplCopyWith<_$ArticleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
