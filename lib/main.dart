import 'package:easy_localization/easy_localization.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';

import 'core/cache/storage/cache_helper.dart';
import 'core/dependency_injection/injectable_config.dart';
import 'core/helper/core/bloc_observer.dart';
import 'core/helper/formatters/date_time_helper.dart';
import 'core/localization/app_locals.dart';
import 'core/presentation/download/download_cubit.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'core/routes/web/url_strategy_web.dart';
import 'core/theme/theme_cubit/theme_cubit.dart';

// Flag to determine if running in local development mode
const bool runLocal = false;

/// Main entry point of the application
/// Initializes all required services and configurations before running the app
void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    //!==================REMOVE COMMENT TO ACTIVE FIREBASE=====================
    // await FirebaseNotifications.initializeFirebase();
  }

  // Initialize shared preferences for local data storage
  await SP.initialSharedPreference();

  await DateTimeHelper.syncNtpOffset();

  // Initialize EasyLocalization for multi-language support
  await EasyLocalization.ensureInitialized();

  // Set custom BLoC observer for debugging state changes
  Bloc.observer = MyBlocObserver();

  // Configure dependency injection container
  configureDependencies();

  // Ensure screen size is calculated for responsive design
  await ScreenUtil.ensureScreenSize();

  // Lock the app to portrait orientation only
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Re-initialize EasyLocalization (duplicate call - may be redundant)
  await EasyLocalization.ensureInitialized();

  //!==================FOR WEB=====================
  // Set path-based URL strategy for web (removes # from URLs)
  setPathUrlStrategy();
  //!==============================================
  // Run the application with localization wrapper
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<DownloadCubit>()),
      ],
      child: EasyLocalization(
        // Supported languages (currently only Arabic)
        supportedLocales: AppLocals.supportedLocales,
        // Default language if preferred language is unavailable
        fallbackLocale: AppLocals.arabicLocal,
        // Initial language on app start
        startLocale: AppLocals.arabicLocal,
        // Path to translation files
        path: AppLocals.assetsLocalization,
        // Main application widget
        child: const App(),
      ),
    ),
  );
}
