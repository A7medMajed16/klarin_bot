import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../cache/storage/cache_helper.dart';
import '../../utils/constants/app_cache_keys.dart';

abstract class UserHelper {
  static bool isLogin() => SP.getBool(key: AppCacheKeys.loginState) != null;
  static Future<void> clearUserData() async {
    SP.clearAll();
    await FSS.clearAll();
    await DefaultCacheManager().emptyCache();
  }
}
