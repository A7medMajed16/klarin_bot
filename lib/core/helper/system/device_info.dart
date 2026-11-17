// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/foundation.dart';
// import 'package:unique_identifier/unique_identifier.dart';
// import 'dart:io';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';

// class DeviceInfoHelper {
//   DeviceInfoHelper._();

//   static Future<String> getPersistentUniqueId() async {
//     final deviceInfo = DeviceInfoPlugin();
//     if (kIsWeb) {
//       return await _generateBrowserFingerprint(deviceInfo);
//     }

//     if (Platform.isAndroid) {
//       return await UniqueIdentifier.serial ?? '';
//     } else if (Platform.isIOS) {
//       var iosDeviceInfo = await deviceInfo.iosInfo;
//       return iosDeviceInfo.identifierForVendor ?? '';
//     } else {
//       return 'unknown_platform';
//     }
//   }

//   static Future<String> _generateBrowserFingerprint(
//     DeviceInfoPlugin deviceInfo,
//   ) async {
//     try {
//       var webInfo = await deviceInfo.webBrowserInfo;

//       List<String> fingerprintComponents = [
//         webInfo.userAgent ?? '',
//         webInfo.vendor ?? '',
//         webInfo.platform ?? '',
//         webInfo.hardwareConcurrency?.toString() ?? '',
//         webInfo.maxTouchPoints?.toString() ?? '',
//         webInfo.languages?.join(',') ?? '',
//         webInfo.productSub ?? '',
//         webInfo.vendorSub ?? '',
//         webInfo.deviceMemory?.toString() ?? '',
//         webInfo.appCodeName ?? '',
//         webInfo.appName ?? '',
//         webInfo.appVersion ?? '',
//         webInfo.browserName.name,
//       ];

//       String combinedFingerprint = fingerprintComponents.join('|');

//       var bytes = utf8.encode(combinedFingerprint);
//       var digest = sha256.convert(bytes);

//       return digest.toString();
//     } catch (e) {
//       var webInfo = await deviceInfo.webBrowserInfo;
//       String fallback =
//           '${webInfo.vendor ?? 'unknown'}_${webInfo.userAgent ?? 'unknown'}';
//       var bytes = utf8.encode(fallback);
//       var digest = sha256.convert(bytes);
//       return digest.toString();
//     }
//   }

//   static Future<String> getDeviceName() async {
//     final deviceInfo = DeviceInfoPlugin();

//     if (kIsWeb) {
//       try {
//         final webInfo = await deviceInfo.webBrowserInfo;
//         final browser = webInfo.browserName.name;
//         return 'Web,$browser';
//       } catch (_) {
//         return 'Web,Unknown';
//       }
//     }

//     try {
//       if (Platform.isAndroid) {
//         final android = await deviceInfo.androidInfo;
//         final manufacturer = android.manufacturer.trim();
//         final model =
//             (android.model.isNotEmpty ? android.model : android.device).trim();
//         final prefix = 'Android';
//         final name = (manufacturer.isNotEmpty)
//             ? '${_capitalize(manufacturer)} $model'
//             : model;
//         return '$prefix,${name.isNotEmpty ? name : 'Android Device'}';
//       } else if (Platform.isIOS) {
//         final ios = await deviceInfo.iosInfo;
//         final prefix = 'iOS';

//         String model = '';
//         if (ios.name.isNotEmpty) model = ios.name;
//         if (ios.model.isNotEmpty && !model.contains(ios.model)) {
//           model = model.isNotEmpty ? '$model ${ios.model}' : ios.model;
//         }

//         if (model.isEmpty) model = ios.utsname.machine;
//         return '$prefix,$model';
//       } else {
//         final info = await deviceInfo.deviceInfo;
//         return 'Unknown,${info.runtimeType}';
//       }
//     } catch (_) {
//       return 'Unknown,Device';
//     }
//   }

//   static String _capitalize(String s) =>
//       s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
// }

// // Backward-compatible top-level wrappers
// Future<String> getPersistentUniqueId() =>
//     DeviceInfoHelper.getPersistentUniqueId();
// Future<String> getDeviceName() => DeviceInfoHelper.getDeviceName();
