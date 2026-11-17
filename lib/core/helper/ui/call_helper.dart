import 'dart:ui' show ImageFilter;

import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class CallHelper {
  CallHelper._();

  static void showCallBottomSheet(BuildContext context, String phoneNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.originalWhite.withValues(alpha: 0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.black27,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                _buildOption(
                  context: context,
                  title: "custom_widget.call".tr(),
                  iconPath: AppAssets.icons.phone.path,
                  color: AppColors.black27,
                  onTap: () => launchLink('tel:$phoneNumber'),
                ),
                const SizedBox(height: 16),
                // _buildOption(
                //   context: context,
                //   title: "custom_widget.whatsapp".tr(),
                //   iconPath: AppAssets.icons.whatsapp.path,
                //   color: AppColors.green00A,
                //   onTap: () =>
                //       launchLink('https://wa.me/$phoneNumber'),
                // ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildOption({
    required BuildContext context,
    required String title,
    required String iconPath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray99),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.1),
              child: SvgPicture.asset(
                iconPath,
                width: 18,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 16),
            Text(title, style: 14.medium.copyWith(color: AppColors.black27)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.gray99),
          ],
        ),
      ),
    );
  }

  static Future<void> launchLink(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (uri.scheme == 'mailto' || uri.scheme == 'tel') {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint("Error launching $url: $e");
    }
  }
}
