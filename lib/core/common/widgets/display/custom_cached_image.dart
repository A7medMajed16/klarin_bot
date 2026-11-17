import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../../api/common/end_points.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_widget_theme.dart';

class CustomCachedImage extends StatelessWidget {
  const CustomCachedImage({
    super.key,
    this.width,
    this.height,
    required this.imagePath,
    this.fit,
    this.emptyColorFilter,
    this.color,
    this.placeholderIcon,
  });

  final double? width, height;
  final String imagePath;
  final ColorFilter? emptyColorFilter;
  final BoxFit? fit;
  final Color? color;
  final IconData? placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final imageUrl = imagePath.isEmpty
        ? ''
        : '${EndPoints.baseImageUrl}$imagePath';

    if (imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color ?? AppWidgetTheme.imageBackgroundColor,
        ),
        child: Center(
          child: Icon(
            placeholderIcon ?? Icons.person_outline,
            size: (width ?? 100).clamp(24, 80),
            color: AppColors.gray71,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      imageUrl: imageUrl,
      color: color,
      fadeInDuration: const Duration(milliseconds: 300),
      errorListener: (value) {
        log('Error loading image: $value');
      },
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppWidgetTheme.imageBackgroundColor,
        ),
        child: Center(
          child: Icon(
            placeholderIcon ?? Icons.person_outline,
            size: (width ?? 100).clamp(24, 80),
            color: AppColors.gray71,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, progress) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppWidgetTheme.imageBackgroundColor,
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CircularProgressIndicator(
              value: progress.progress,
              color: AppWidgetTheme.loadingIndicatorColor,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ),
    );
  }
}
