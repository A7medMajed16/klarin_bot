import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class DialogHelper {
  static void showCustomDialog({
    required BuildContext context,
    required TapDownDetails details,
    void Function()? firstOptionFunction,
    void Function()? secondOptionFunction,
    required List<DialogItem> items,
    String? menuTitle,
    bool withIcons = true,
    bool rightAligned = false,
    bool center = false,
  }) {
    // Calculate position from top based on tap position
    final double topPosition = details.globalPosition.dy + 10;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
            Positioned(
              left: center
                  ? null
                  : rightAligned
                  ? null
                  : 16,
              right: center
                  ? null
                  : rightAligned
                  ? 16
                  : null,
              top: topPosition - 40.h,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 140.w.clamp(130, 140),
                  decoration: BoxDecoration(
                    color: AppColors.originalWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      menuTitle != null
                          ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(menuTitle, style: 16.medium),
                            )
                          : const SizedBox(height: 24),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            items[index].onTap?.call();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 20.w.clamp(18, 20),
                              children: [
                                if (withIcons &&
                                    items[index].iconPath != null &&
                                    items[index].iconPath!.isNotEmpty)
                                  SvgPicture.asset(
                                    items[index].iconPath!,
                                    width: 20,
                                    colorFilter: ColorFilter.mode(
                                      items[index].iconColor ??
                                          AppColors.primerColor,
                                      BlendMode.srcIn,
                                    ),
                                    fit: BoxFit.scaleDown,
                                  ),
                                if (items[index].title != null)
                                  Text(
                                    items[index].title!,
                                    style: 14.medium.copyWith(
                                      color:
                                          items[index].iconColor ??
                                          AppColors.primerColor,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 8),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DialogItem {
  final String? title;
  final String? iconPath;
  final Color? iconColor;
  final VoidCallback? onTap;

  DialogItem({this.title, this.iconPath, this.iconColor, this.onTap});
}
