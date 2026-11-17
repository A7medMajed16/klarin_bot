import 'package:auto_route/auto_route.dart';

import 'app_route_definitions.dart';

final appRouter = AppRouter();

/// Central route table: path + generated [PageInfo], optional nested children.
final _appRouteTable = <AppRouteDefinition>[
  // AppRouteDefinition(path: Routes.appBlocked, page: AppBlockedScreenRoute.page),
  // AppRouteDefinition(
  //   path: Routes.imageViewer,
  //   page: ImageViewerScreenRoute.page,
  // ),
  // AppRouteDefinition(
  //   path: Routes.splash,
  //   page: SplashScreenRoute.page,
  //   initial: true,
  // ),
];

@AutoRouterConfig(replaceInRouteName: 'Screen,Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => buildSlideCustomRoutes(
    _appRouteTable,
    transitionsBuilder: appSlideTransition,
  );
}
