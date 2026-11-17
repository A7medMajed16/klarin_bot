import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_widget_theme.dart';

class PopupHelper {
  static Future<void> showCustomPopupMenu({
    required BuildContext context,
    required Offset position,
    required List<DialogItem> items,
    String? menuTitle,
    bool withIcons = true,
    bool rightAligned = false,
    bool center = false,
    bool recolorIcons = true,
    double? radius,
    double? width,
    Color? backgroundColor,
  }) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromDirectional(
        textDirection: Directionality.of(context) == TextDirection.ltr
            ? TextDirection.rtl
            : TextDirection.ltr,
        start: position.dx,
        top: position.dy - 105,
        end: position.dx + 1,
        bottom: position.dy + 1,
      ),
      color: backgroundColor ?? AppColors.originalWhite,
      shadowColor: AppColors.originalBlack.withValues(alpha: 0.5),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: radius != null
            ? BorderRadiusGeometry.circular(radius)
            : BorderRadiusDirectional.only(
                topStart: Radius.circular(12),
                topEnd: Radius.circular(0),
                bottomStart: Radius.circular(12),
                bottomEnd: Radius.circular(12),
              ),
      ),
      constraints: BoxConstraints(maxWidth: width ?? 200),
      menuPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      items: <PopupMenuEntry<dynamic>>[
        if (menuTitle != null)
          PopupMenuItem<dynamic>(
            enabled: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(menuTitle, style: 16.medium),
            ),
          ),
        for (int i = 0; i < items.length; i++) ...[
          PopupMenuItem<dynamic>(
            onTap: items[i].onTap,

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (withIcons &&
                    items[i].iconPath != null &&
                    items[i].iconPath!.isNotEmpty)
                  SvgPicture.asset(
                    items[i].iconPath!,
                    width: 20,
                    colorFilter: recolorIcons
                        ? ColorFilter.mode(
                            items[i].iconColor ??
                                AppWidgetTheme.popUpIconDefaultColor,
                            BlendMode.srcIn,
                          )
                        : null,
                    fit: BoxFit.scaleDown,
                  ),
                if (items[i].title != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: Text(
                      items[i].title!,
                      style: 14.medium.copyWith(
                        color:
                            items[i].iconColor ??
                            AppWidgetTheme.popUpIconDefaultColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (i < items.length - 1)
            const PopupMenuDivider(
              height: 0.5,
              color: AppWidgetTheme.popUpDividerDefaultColor,
            ),
        ],
      ],
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
