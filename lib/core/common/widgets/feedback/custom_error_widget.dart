import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

import '../../../theme/app_typography.dart';
import '../buttons/custom_button.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    this.errorMessage,
    this.onPressed,
    this.color,
  });

  final String? errorMessage;
  final void Function()? onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              errorMessage ?? "custom_widget.unexpected_error".tr(),
              style: 16.regular,
            ),
            const SizedBox(height: 16),
            if (onPressed != null)
              CustomButton(
                title: "custom_widget.try_again".tr(),
                onTap: onPressed ?? () {},
              ),
          ],
        ),
      ),
    );
  }
}
