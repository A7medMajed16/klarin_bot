import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../theme/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: () async => await onRefresh(),
      color: AppColors.primerColor,
      backgroundColor: AppColors.originalWhite,
      height: 0.1.sh,
      showChildOpacityTransition: false,
      animSpeedFactor: 2,
      child: child,
    );
  }
}
