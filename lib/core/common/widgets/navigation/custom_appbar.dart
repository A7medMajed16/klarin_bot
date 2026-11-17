import 'dart:ui' show ImageFilter;

import 'package:auto_route/auto_route.dart'
    show AutoLeadingButton, AutoRouterX;
import 'package:material_ui/material_ui.dart';

import '../../../theme/app_typography.dart';

AppBar customAppBar({
  String? title,
  bool withAnimation = false,
  bool withTransparentBackground = true,
  bool useBlurEffect = false,
  void Function()? onTap,
}) {
  return AppBar(
    leadingWidth: 35,
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: withTransparentBackground
        ? Colors.transparent
        : null,
    flexibleSpace: useBlurEffect
        ? ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(color: Colors.transparent),
            ),
          )
        : null,
    title: title != null
        ? withAnimation
              ? TweenAnimationBuilder<Offset>(
                  tween: Tween<Offset>(
                    begin: const Offset(0.5, 0),
                    end: Offset.zero,
                  ),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOutBack,
                  builder: (context, offset, child) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeInOut,
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: Transform.translate(
                            offset: offset * 30,
                            child: child,
                          ),
                        );
                      },
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          if (context.router.canPop()) {
                            context.pop();
                          }
                        },
                        child: Text(title, style: 20.semiBold),
                      ),
                    );
                  },
                )
              : Hero(
                  tag: title,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(title, style: 18.regular),
                  ),
                )
        : null,
    leading: AutoLeadingButton(
      showIfChildCanPop: true,
      builder: (context, leadingType, action) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: InkWell(
            onTap: action,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        );
      },
    ),
  );
}
