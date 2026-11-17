// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadCubitState {

 String get fileName; StateStatus<String> get downloadStatus;
/// Create a copy of DownloadCubitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadCubitStateCopyWith<DownloadCubitState> get copyWith => _$DownloadCubitStateCopyWithImpl<DownloadCubitState>(this as DownloadCubitState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DownloadCubitState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadCubitState&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.downloadStatus, _this.downloadStatus) || other.downloadStatus == _this.downloadStatus));
}


@override
int get hashCode {
  final _this = this as DownloadCubitState;
  return Object.hash(runtimeType,_this.fileName,_this.downloadStatus);
}

@override
String toString() {
  final _this = this as DownloadCubitState;
  return 'DownloadCubitState(fileName: ${_this.fileName}, downloadStatus: ${_this.downloadStatus})';
}


}

/// @nodoc
abstract mixin class $DownloadCubitStateCopyWith<$Res>  {
  factory $DownloadCubitStateCopyWith(DownloadCubitState value, $Res Function(DownloadCubitState) _then) = _$DownloadCubitStateCopyWithImpl;
@useResult
$Res call({
 String fileName, StateStatus<String> downloadStatus
});


$StateStatusCopyWith<String, $Res> get downloadStatus;

}
/// @nodoc
class _$DownloadCubitStateCopyWithImpl<$Res>
    implements $DownloadCubitStateCopyWith<$Res> {
  _$DownloadCubitStateCopyWithImpl(this._self, this._then);

  final DownloadCubitState _self;
  final $Res Function(DownloadCubitState) _then;

/// Create a copy of DownloadCubitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? downloadStatus = null,}) {
  return _then(DownloadCubitState(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,downloadStatus: null == downloadStatus ? _self.downloadStatus : downloadStatus // ignore: cast_nullable_to_non_nullable
as StateStatus<String>,
  ));
}
/// Create a copy of DownloadCubitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StateStatusCopyWith<String, $Res> get downloadStatus {
  
  return $StateStatusCopyWith<String, $Res>(_self.downloadStatus, (value) {
    return _then(_self.copyWith(downloadStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [DownloadCubitState].
extension DownloadCubitStatePatterns on DownloadCubitState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadCubitState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadCubitState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadCubitState value)  $default,){
final _that = this;
switch (_that) {
case _DownloadCubitState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadCubitState value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadCubitState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  StateStatus<String> downloadStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadCubitState() when $default != null:
return $default(_that.fileName,_that.downloadStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  StateStatus<String> downloadStatus)  $default,) {final _that = this;
switch (_that) {
case _DownloadCubitState():
return $default(_that.fileName,_that.downloadStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  StateStatus<String> downloadStatus)?  $default,) {final _that = this;
switch (_that) {
case _DownloadCubitState() when $default != null:
return $default(_that.fileName,_that.downloadStatus);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadCubitState implements DownloadCubitState {
  const _DownloadCubitState({this.fileName = '', this.downloadStatus = const StateStatus<String>.initial()});
  

@override@JsonKey() final  String fileName;
@override@JsonKey() final  StateStatus<String> downloadStatus;

/// Create a copy of DownloadCubitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadCubitStateCopyWith<_DownloadCubitState> get copyWith => __$DownloadCubitStateCopyWithImpl<_DownloadCubitState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadCubitState&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.downloadStatus, downloadStatus) || other.downloadStatus == downloadStatus));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fileName,downloadStatus);
}

@override
String toString() {
    return 'DownloadCubitState(fileName: $fileName, downloadStatus: $downloadStatus)';
}


}

/// @nodoc
abstract mixin class _$DownloadCubitStateCopyWith<$Res> implements $DownloadCubitStateCopyWith<$Res> {
  factory _$DownloadCubitStateCopyWith(_DownloadCubitState value, $Res Function(_DownloadCubitState) _then) = __$DownloadCubitStateCopyWithImpl;
@override @useResult
$Res call({
 String fileName, StateStatus<String> downloadStatus
});


@override $StateStatusCopyWith<String, $Res> get downloadStatus;

}
/// @nodoc
class __$DownloadCubitStateCopyWithImpl<$Res>
    implements _$DownloadCubitStateCopyWith<$Res> {
  __$DownloadCubitStateCopyWithImpl(this._self, this._then);

  final _DownloadCubitState _self;
  final $Res Function(_DownloadCubitState) _then;

/// Create a copy of DownloadCubitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? downloadStatus = null,}) {
  return _then(_DownloadCubitState(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,downloadStatus: null == downloadStatus ? _self.downloadStatus : downloadStatus // ignore: cast_nullable_to_non_nullable
as StateStatus<String>,
  ));
}

/// Create a copy of DownloadCubitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StateStatusCopyWith<String, $Res> get downloadStatus {
  
  return $StateStatusCopyWith<String, $Res>(_self.downloadStatus, (value) {
    return _then(_self.copyWith(downloadStatus: value));
  });
}
}

// dart format on
