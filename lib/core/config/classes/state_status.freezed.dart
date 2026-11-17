// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StateStatus<T> {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StateStatus<T>);
}


@override
int get hashCode => runtimeType.hashCode;



}

/// @nodoc
class $StateStatusCopyWith<T,$Res>  {
$StateStatusCopyWith(StateStatus<T> _, $Res Function(StateStatus<T>) __);
}


/// Adds pattern-matching-related methods to [StateStatus].
extension StateStatusPatterns<T> on StateStatus<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial<T> value)?  initial,TResult Function( _Loading<T> value)?  loading,TResult Function( _UpdateUi<T> value)?  updateUi,TResult Function( _LoadingMore<T> value)?  loadingMore,TResult Function( _Success<T> value)?  success,TResult Function( _Failure<T> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _UpdateUi() when updateUi != null:
return updateUi(_that);case _LoadingMore() when loadingMore != null:
return loadingMore(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial<T> value)  initial,required TResult Function( _Loading<T> value)  loading,required TResult Function( _UpdateUi<T> value)  updateUi,required TResult Function( _LoadingMore<T> value)  loadingMore,required TResult Function( _Success<T> value)  success,required TResult Function( _Failure<T> value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _UpdateUi():
return updateUi(_that);case _LoadingMore():
return loadingMore(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial<T> value)?  initial,TResult? Function( _Loading<T> value)?  loading,TResult? Function( _UpdateUi<T> value)?  updateUi,TResult? Function( _LoadingMore<T> value)?  loadingMore,TResult? Function( _Success<T> value)?  success,TResult? Function( _Failure<T> value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _UpdateUi() when updateUi != null:
return updateUi(_that);case _LoadingMore() when loadingMore != null:
return loadingMore(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( T? data)?  initial,TResult Function( int? index,  double? progress,  DateTime? time)?  loading,TResult Function( T? data,  DateTime? time)?  updateUi,TResult Function( T? data,  DateTime? time)?  loadingMore,TResult Function( T? data,  DateTime? time)?  success,TResult Function( Failure failure,  DateTime? time)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.data);case _Loading() when loading != null:
return loading(_that.index,_that.progress,_that.time);case _UpdateUi() when updateUi != null:
return updateUi(_that.data,_that.time);case _LoadingMore() when loadingMore != null:
return loadingMore(_that.data,_that.time);case _Success() when success != null:
return success(_that.data,_that.time);case _Failure() when failure != null:
return failure(_that.failure,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( T? data)  initial,required TResult Function( int? index,  double? progress,  DateTime? time)  loading,required TResult Function( T? data,  DateTime? time)  updateUi,required TResult Function( T? data,  DateTime? time)  loadingMore,required TResult Function( T? data,  DateTime? time)  success,required TResult Function( Failure failure,  DateTime? time)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.data);case _Loading():
return loading(_that.index,_that.progress,_that.time);case _UpdateUi():
return updateUi(_that.data,_that.time);case _LoadingMore():
return loadingMore(_that.data,_that.time);case _Success():
return success(_that.data,_that.time);case _Failure():
return failure(_that.failure,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( T? data)?  initial,TResult? Function( int? index,  double? progress,  DateTime? time)?  loading,TResult? Function( T? data,  DateTime? time)?  updateUi,TResult? Function( T? data,  DateTime? time)?  loadingMore,TResult? Function( T? data,  DateTime? time)?  success,TResult? Function( Failure failure,  DateTime? time)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.data);case _Loading() when loading != null:
return loading(_that.index,_that.progress,_that.time);case _UpdateUi() when updateUi != null:
return updateUi(_that.data,_that.time);case _LoadingMore() when loadingMore != null:
return loadingMore(_that.data,_that.time);case _Success() when success != null:
return success(_that.data,_that.time);case _Failure() when failure != null:
return failure(_that.failure,_that.time);case _:
  return null;

}
}

}

/// @nodoc


class _Initial<T> extends StateStatus<T> {
  const _Initial({this.data}): super._();
  

 final  T? data;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<T, _Initial<T>> get copyWith => __$InitialCopyWithImpl<T, _Initial<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data));
}



}

/// @nodoc
abstract mixin class _$InitialCopyWith<T,$Res> implements $StateStatusCopyWith<T, $Res> {
  factory _$InitialCopyWith(_Initial<T> value, $Res Function(_Initial<T>) _then) = __$InitialCopyWithImpl;
@useResult
$Res call({
 T? data
});




}
/// @nodoc
class __$InitialCopyWithImpl<T,$Res>
    implements _$InitialCopyWith<T, $Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial<T> _self;
  final $Res Function(_Initial<T>) _then;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_Initial<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}


}

/// @nodoc


class _Loading<T> extends StateStatus<T> {
  const _Loading({this.index, this.progress, this.time}): super._();
  

 final  int? index;
 final  double? progress;
 final  DateTime? time;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<T, _Loading<T>> get copyWith => __$LoadingCopyWithImpl<T, _Loading<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading<T>&&(identical(other.index, index) || other.index == index)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,index,progress,time);
}



}

/// @nodoc
abstract mixin class _$LoadingCopyWith<T,$Res> implements $StateStatusCopyWith<T, $Res> {
  factory _$LoadingCopyWith(_Loading<T> value, $Res Function(_Loading<T>) _then) = __$LoadingCopyWithImpl;
@useResult
$Res call({
 int? index, double? progress, DateTime? time
});




}
/// @nodoc
class __$LoadingCopyWithImpl<T,$Res>
    implements _$LoadingCopyWith<T, $Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading<T> _self;
  final $Res Function(_Loading<T>) _then;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = freezed,Object? progress = freezed,Object? time = freezed,}) {
  return _then(_Loading<T>(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class _UpdateUi<T> extends StateStatus<T> {
  const _UpdateUi({this.data, this.time}): super._();
  

 final  T? data;
 final  DateTime? time;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUiCopyWith<T, _UpdateUi<T>> get copyWith => __$UpdateUiCopyWithImpl<T, _UpdateUi<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUi<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data),time);
}



}

/// @nodoc
abstract mixin class _$UpdateUiCopyWith<T,$Res> implements $StateStatusCopyWith<T, $Res> {
  factory _$UpdateUiCopyWith(_UpdateUi<T> value, $Res Function(_UpdateUi<T>) _then) = __$UpdateUiCopyWithImpl;
@useResult
$Res call({
 T? data, DateTime? time
});




}
/// @nodoc
class __$UpdateUiCopyWithImpl<T,$Res>
    implements _$UpdateUiCopyWith<T, $Res> {
  __$UpdateUiCopyWithImpl(this._self, this._then);

  final _UpdateUi<T> _self;
  final $Res Function(_UpdateUi<T>) _then;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? time = freezed,}) {
  return _then(_UpdateUi<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class _LoadingMore<T> extends StateStatus<T> {
  const _LoadingMore({this.data, this.time}): super._();
  

 final  T? data;
 final  DateTime? time;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingMoreCopyWith<T, _LoadingMore<T>> get copyWith => __$LoadingMoreCopyWithImpl<T, _LoadingMore<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadingMore<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data),time);
}



}

/// @nodoc
abstract mixin class _$LoadingMoreCopyWith<T,$Res> implements $StateStatusCopyWith<T, $Res> {
  factory _$LoadingMoreCopyWith(_LoadingMore<T> value, $Res Function(_LoadingMore<T>) _then) = __$LoadingMoreCopyWithImpl;
@useResult
$Res call({
 T? data, DateTime? time
});




}
/// @nodoc
class __$LoadingMoreCopyWithImpl<T,$Res>
    implements _$LoadingMoreCopyWith<T, $Res> {
  __$LoadingMoreCopyWithImpl(this._self, this._then);

  final _LoadingMore<T> _self;
  final $Res Function(_LoadingMore<T>) _then;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? time = freezed,}) {
  return _then(_LoadingMore<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class _Success<T> extends StateStatus<T> {
  const _Success({this.data, this.time}): super._();
  

 final  T? data;
 final  DateTime? time;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<T, _Success<T>> get copyWith => __$SuccessCopyWithImpl<T, _Success<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data),time);
}



}

/// @nodoc
abstract mixin class _$SuccessCopyWith<T,$Res> implements $StateStatusCopyWith<T, $Res> {
  factory _$SuccessCopyWith(_Success<T> value, $Res Function(_Success<T>) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 T? data, DateTime? time
});




}
/// @nodoc
class __$SuccessCopyWithImpl<T,$Res>
    implements _$SuccessCopyWith<T, $Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success<T> _self;
  final $Res Function(_Success<T>) _then;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? time = freezed,}) {
  return _then(_Success<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class _Failure<T> extends StateStatus<T> {
  const _Failure({required this.failure, this.time}): super._();
  

 final  Failure failure;
 final  DateTime? time;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<T, _Failure<T>> get copyWith => __$FailureCopyWithImpl<T, _Failure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure<T>&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure,time);
}



}

/// @nodoc
abstract mixin class _$FailureCopyWith<T,$Res> implements $StateStatusCopyWith<T, $Res> {
  factory _$FailureCopyWith(_Failure<T> value, $Res Function(_Failure<T>) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 Failure failure, DateTime? time
});




}
/// @nodoc
class __$FailureCopyWithImpl<T,$Res>
    implements _$FailureCopyWith<T, $Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure<T> _self;
  final $Res Function(_Failure<T>) _then;

/// Create a copy of StateStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? time = freezed,}) {
  return _then(_Failure<T>(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
