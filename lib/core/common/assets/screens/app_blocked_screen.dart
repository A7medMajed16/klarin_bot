// import 'package:auto_route/auto_route.dart';
// import 'package:easy_localization/easy_localization.dart'
//     show StringTranslateExtension;
// import 'package:flutter/material.dart';

// import '../../../theme/app_colors.dart';
// import '../../../theme/app_typography.dart';

// @RoutePage()
// class AppBlockedScreen extends StatelessWidget {
//   const AppBlockedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black0D,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const .all(12),
//                 decoration: BoxDecoration(
//                   color: AppColors.redDC.withValues(alpha: 0.3),
//                   shape: .circle,
//                 ),
//                 child: const Icon(
//                   Icons.error_rounded,
//                   size: 50,
//                   color: AppColors.redDC,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               Text(
//                 "app_blocking.title".tr(),
//                 textAlign: TextAlign.center,
//                 style: 22.bold.copyWith(color: AppColors.whiteF9),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "app_blocking.description".tr(),
//                 textAlign: TextAlign.center,
//                 style: 16.regular.copyWith(color: AppColors.gray6E),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
