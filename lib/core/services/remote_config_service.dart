// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';
// import '../../firebase_options.dart';
// import '../config/storage/cache_helper.dart';

// class RemoteConfigService {
//   static final RemoteConfigService _instance =
//       RemoteConfigService._internal();
//   factory RemoteConfigService() => _instance;
//   RemoteConfigService._internal();

//   static const String _appEnabledKey = 'app_enabled';

//   Future<void> init() async {
//     try {
//       if (Firebase.apps.isEmpty) {
//         await Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         );
//       }
//       final remoteConfig = FirebaseRemoteConfig.instance;
//       await remoteConfig.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(minutes: 1),
//           minimumFetchInterval: kDebugMode
//               ? const Duration(seconds: 10)
//               : const Duration(hours: 1),
//         ),
//       );

//       await remoteConfig.setDefaults(const {_appEnabledKey: true});
//       await remoteConfig.fetchAndActivate();
//       final isEnabled = remoteConfig.getBool(_appEnabledKey);
//       await SP.setBool(key: _appEnabledKey, value: isEnabled);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Remote Config initialization failed: $e');
//       }
//     }
//   }

//   Future<bool> isAppEnabled() async {
//     try {
//       final remoteConfig = FirebaseRemoteConfig.instance;
//       return remoteConfig.getBool(_appEnabledKey);
//     } catch (e) {
//       return SP.getBool(key: _appEnabledKey) ?? true;
//     }
//   }
// }
