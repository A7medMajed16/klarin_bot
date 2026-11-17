import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class AppVersion extends StatefulWidget {
  const AppVersion({super.key});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getAppVersion(),
      builder: (context, snapshot) {
        final version = snapshot.data ?? '...';
        return Text(
          "v$version",
          style: 16.regular.copyWith(
            color: AppColors.black27.withValues(alpha: 0.3),
          ),
        );
      },
    );
  }
}
