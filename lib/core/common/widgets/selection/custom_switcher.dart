import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../theme/app_widget_theme.dart';

class CustomSwitcher extends StatelessWidget {
  final bool value;
  final void Function(bool)? onChanged;
  const CustomSwitcher({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: true,
      child: SizedBox(
        height: 24,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged ?? (value) {},
            activeTrackColor: AppWidgetTheme.switchActiveColor,
          ),
        ),
      ),
    );
  }
}
