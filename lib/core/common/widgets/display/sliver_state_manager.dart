import 'package:material_ui/material_ui.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../config/classes/state_status.dart';
import '../../../theme/app_animation_curves.dart';
import '../feedback/custom_error_widget.dart';

class SliversStateManager<T> extends StatelessWidget {
  const SliversStateManager({
    super.key,
    required this.state,
    required this.successSliver,
    required this.loadingSliver,
    this.failureSliver,
    this.emptyDataSliver,
    this.onRetry,
    this.duration = const Duration(milliseconds: 800),
  });

  final StateStatus<T> state;
  final Widget successSliver;
  final Widget loadingSliver;
  final Widget? failureSliver;
  final Widget? emptyDataSliver;
  final VoidCallback? onRetry;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedSwitcher(
      duration: duration,
      switchInCurve: AppAnimationCurves.androidCurve,
      switchOutCurve: AppAnimationCurves.androidCurve,
      child: state.isLoading
          ? KeyedSubtree(
              key: const ValueKey("loading_sliver"),
              child: loadingSliver,
            )
          : state.isFailure
          ? KeyedSubtree(
              key: const ValueKey("failure_sliver"),
              child:
                  failureSliver ??
                  SliverToBoxAdapter(
                    child: CustomErrorWidget(
                      errorMessage: state.failure?.errorMessage,
                      onPressed: onRetry,
                    ),
                  ),
            )
          : (state.isSuccess &&
                state.data is List &&
                (state.data as List).isEmpty)
          ? KeyedSubtree(
              key: const ValueKey("empty_data_sliver"),
              child:
                  emptyDataSliver ??
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            )
          : KeyedSubtree(
              key: const ValueKey("success_sliver"),
              child: successSliver,
            ),
    );
  }
}
