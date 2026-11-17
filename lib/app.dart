import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/theme_cubit/theme_cubit.dart';
import 'core/utils/constants/app_strings.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

/// Root widget of the Al Ertiqa application
/// Handles platform-specific theming and responsive design setup
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        final brightness = isDarkMode ? Brightness.dark : Brightness.light;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDarkMode
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDarkMode
                ? Brightness.dark
                : Brightness.light,
            systemNavigationBarColor: isDarkMode
                ? AppColors.black0D
                : AppColors.originalWhite,
            systemNavigationBarIconBrightness: isDarkMode
                ? Brightness.light
                : Brightness.dark,
          ),
        );

        AppTypography.setTheme(brightness);
        AppTypography.setLocale(context.locale.languageCode);

        if (kIsWeb) {
          return _buildMaterialApp(context, isDarkMode);
        }

        // Apply Cupertino theme wrapper for iOS devices to maintain native look
        return Platform.isIOS
            ? CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: brightness,
                  // Set primary color for iOS native components
                  primaryColor: AppColors.primerColor,
                  // Set background color for scaffold
                  scaffoldBackgroundColor: isDarkMode
                      ? AppColors.black0D
                      : AppColors.originalWhite,
                  // Set navigation bar background color
                  barBackgroundColor: isDarkMode
                      ? AppColors.black0D
                      : AppColors.originalWhite,
                  // Configure text styling for iOS components
                  textTheme: CupertinoTextThemeData(
                    textStyle: TextStyle(
                      // Use Arabic font family for all text
                      fontFamily: AppStrings.arabicFontFamily,
                    ),
                  ),
                ),
                child: _buildMaterialApp(context, isDarkMode),
              )
            : _buildMaterialApp(context, isDarkMode);
      },
    );
  }

  /// Builds the MaterialApp with responsive design and localization support
  Widget _buildMaterialApp(BuildContext context, bool isDarkMode) {
    return ScreenUtilInit(
      // Set design size based on platform (web vs mobile)
      designSize: kIsWeb
          ? const Size(1440, 1024) // Desktop web size
          : const Size(375, 812), // Mobile size (iPhone X)
      // Enable minimum text adaptation for accessibility
      minTextAdapt: true,
      // Use inherited media query for better performance
      useInheritedMediaQuery: true,
      builder: (context, Widget? child) {
        return MaterialApp.router(
          // Integrate EasyLocalization delegates for multi-language support
          localizationsDelegates: context.localizationDelegates,
          // Define supported locales from EasyLocalization
          supportedLocales: context.supportedLocales,
          // Set current active locale
          locale: context.locale,
          // Configure app routing using GoRouter
          routerConfig: appRouter.config(),
          // Hide debug banner in top-right corner
          debugShowCheckedModeBanner: false,
          // Apply theme based on dark mode state
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
