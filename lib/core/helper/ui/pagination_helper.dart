import 'package:material_ui/material_ui.dart';

/// A helper widget that handle pagination by listening to scroll notifications.
/// It detects when the user reaches the bottom of the scrollable area and
/// triggers the [onLoadMore] callback.
class PaginationHelper extends StatelessWidget {
  /// The scrollable widget (e.g., ListView, CustomScrollView).
  final Widget child;

  /// Callback triggered when the user scrolls near the bottom.
  final VoidCallback onLoadMore;

  /// Whether a "load more" operation is currently in progress.
  final bool isLoadingMore;

  /// Whether there are more items to load.
  final bool hasMore;

  /// The distance from the bottom at which to trigger [onLoadMore].
  final double threshold;

  final Axis axis;

  const PaginationHelper({
    super.key,
    required this.child,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasMore,
    this.threshold = 200,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          final metrics = notification.metrics;
          if ((metrics.pixels > 0 &&
                  metrics.maxScrollExtent - metrics.pixels <
                      threshold &&
                  hasMore &&
                  !isLoadingMore) &&
              metrics.axis == axis) {
            onLoadMore();
          }
        }
        return false;
      },
      child: child,
    );
  }
}
