import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../api/errors/failure.dart';
import '../classes/state_status.dart';

mixin PaginatedMixin<S, T> on Cubit<S> {
  int _page = 1;
  bool _hasMore = true;
  List<T> _items = [];

  /// The number of items to fetch per page.
  int get itemsPerPage => 20;

  bool get hasMore => _hasMore;
  List<T> get items => List.unmodifiable(_items);

  bool _isLoading = false;

  /// Executes a paginated API call and manages the state.
  ///
  /// [apiCall] A function that takes the current page and returns an Either of Failure or List.
  /// [stateField] A function that maps the resulting StateStatus to the Cubit's state.
  Future<void> fetchPaginated({
    required Future<Either<Failure, List<T>>> Function(int page) apiCall,
    required S Function(StateStatus<List<T>> status) stateField,
    bool isRefresh = false,
    CancelToken? cancelToken,
  }) async {
    // On refresh: allow interrupting the current in-flight request
    if (_isLoading && !isRefresh) return;

    if (isRefresh) {
      resetPagination();
    }

    if (!_hasMore) return;

    _isLoading = true;

    if (_page == 1) {
      emit(stateField(StateStatus.loading(time: DateTime.now())));
    } else {
      emit(
        stateField(StateStatus.loadingMore(data: _items, time: DateTime.now())),
      );
    }

    final result = await apiCall(_page);

    result.fold(
      (failure) {
        // Silently ignore cancelled / superseded requests — never emit failure.
        if (failure is RequestCancelledFailure) {
          _isLoading = false;
          return;
        }

        _isLoading = false;
        emit(
          stateField(
            StateStatus.failure(failure: failure, time: DateTime.now()),
          ),
        );
      },
      (newItems) {
        if (newItems.isEmpty || newItems.length < itemsPerPage) {
          _hasMore = false;
        }
        _items = [..._items, ...newItems];
        _page++;
        emit(
          stateField(StateStatus.success(data: _items, time: DateTime.now())),
        );
        // Delay releasing the loading lock to allow the widget tree
        // to settle after a refresh, preventing PaginationHelper from
        // immediately re-triggering onLoadMore.
        Future.delayed(
          const Duration(milliseconds: 300),
          () => _isLoading = false,
        );
      },
    );
  }

  /// Resets pagination state to initial values.
  void resetPagination() {
    _page = 1;
    _hasMore = true;
    _items = [];
  }
}
