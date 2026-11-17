import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/extensions/theme_extensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'download_cubit.dart';

class DownloadAppBarProgress extends StatelessWidget implements PreferredSizeWidget {
  const DownloadAppBarProgress({super.key});

  static const double _visibleHeight = 52;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return BlocBuilder<DownloadCubit, DownloadCubitState>(
      buildWhen: (previous, current) =>
          previous.downloadStatus != current.downloadStatus ||
          previous.fileName != current.fileName,
      builder: (context, state) {
        final status = state.downloadStatus;
        if (status.isInitial) {
          return const SizedBox.shrink();
        }

        final progressValue = status.isLoading
            ? (status.progress ?? 0)
            : status.isSuccess
            ? 1.0
            : 0.0;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: 12.regular.copyWith(
                  color: isDarkMode ? AppColors.gray9D : AppColors.gray6C,
                ),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: status.isFailure ? null : progressValue,
                minHeight: 4,
                borderRadius: BorderRadius.circular(999),
                backgroundColor:
                    isDarkMode ? AppColors.gray38 : AppColors.whitE5,
                color: status.isFailure
                    ? AppColors.redB4
                    : AppColors.primerColor,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_visibleHeight);
}
