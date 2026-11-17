//! OPTIONAL "location": requires geolocator, geocoding, latlong2, map_launcher.
//! Enable it in Automation_dart/init_project_folders.dart (optionalFeatures).
//#optional:location
// import 'package:easy_localization/easy_localization.dart';
// import 'package:material_ui/material_ui.dart';
// import 'package:map_launcher/map_launcher.dart';
// import '../../../theme/app_colors.dart';
// import '../../../theme/app_typography.dart';

// class MapChooserBottomSheet extends StatelessWidget {
//   final List<SupportedMap> availableMaps;

//   const MapChooserBottomSheet({super.key, required this.availableMaps});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       decoration: const BoxDecoration(
//         color: AppColors.originalWhite,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Text('custom_widget.choose_map'.tr(), style: 16.bold),
//             ),
//             const Divider(),
//             Flexible(
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 itemCount: availableMaps.length,
//                 separatorBuilder: (context, index) =>
//                     const SizedBox(height: 10),
//                 itemBuilder: (context, index) {
//                   final map = availableMaps[index];
//                   return ListTile(
//                     onTap: () async {
//                       Navigator.pop(context);
//                       await map.show();
//                     },
//                     leading: Image.memory(map.iconBytes, height: 30, width: 30),
//                     title: Text(map.name, style: 14.medium),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       side: BorderSide(color: AppColors.gray99),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//#end-optional:location
