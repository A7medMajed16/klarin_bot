import 'package:equatable/equatable.dart';

abstract class BaseParams extends Equatable {
  const BaseParams();

  Map<String, dynamic> toJson();
}

class NoParams extends BaseParams {
  const NoParams();

  static const instance = NoParams();

  @override
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [];
}

mixin PaginationMixin {
  int get page;
  int get limit;

  Map<String, dynamic> get paginationMap => {
    'page': page,
    'limit': limit,
  };
}
