import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';

import 'dart:async';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ResendTimer extends StatefulWidget {
  const ResendTimer({super.key, required this.onResend});
  final Function() onResend;
  @override
  ResendTimerState createState() => ResendTimerState();
}

class ResendTimerState extends State<ResendTimer> {
  int _remainingSeconds = 30;
  int _timerCount = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _handleResend() {
    setState(() {
      _remainingSeconds += 30 * _timerCount;
      _timerCount++;
    });

    if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _timer == null || !_timer!.isActive
          ? () {
              _handleResend();
              widget.onResend();
            }
          : null,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: _remainingSeconds > 0
          ? RichText(
              text: TextSpan(
                style: 14.light.copyWith(color: AppColors.black27),
                children: [
                  TextSpan(text: 'custom_widget.resend'.tr().split('{}').first),
                  TextSpan(
                    text: _formatTime(_remainingSeconds),
                    style: 14.bold.copyWith(color: AppColors.black27),
                  ),
                  if ('custom_widget.resend'.tr().contains('{}') &&
                      'custom_widget.resend'.tr().split('{}').length > 1)
                    TextSpan(
                      text: 'custom_widget.resend'.tr().split('{}').last,
                    ),
                ],
              ),
            )
          : Text(
              'custom_widget.resend_title'.tr(),
              style: 14.light.copyWith(color: AppColors.black27),
            ),
    );
  }
}
