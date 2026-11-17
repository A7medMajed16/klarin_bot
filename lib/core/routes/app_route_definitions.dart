import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

/// Declarative route entry: [path], [page], optional nested [children].
class AppRouteDefinition {
  const AppRouteDefinition({
    required this.path,
    required this.page,
    this.initial = false,
    this.children = const [],
  });

  final String path;
  final PageInfo page;
  final bool initial;
  final List<AppRouteDefinition> children;
}

const kAppRouteTransitionDuration = Duration(milliseconds: 450);

List<AutoRoute> buildSlideCustomRoutes(
  List<AppRouteDefinition> definitions, {
  required RouteTransitionsBuilder transitionsBuilder,
  Duration duration = kAppRouteTransitionDuration,
}) {
  return definitions
      .map(
        (definition) => _toSlideCustomRoute(
          definition,
          transitionsBuilder: transitionsBuilder,
          duration: duration,
        ),
      )
      .toList();
}

CustomRoute _toSlideCustomRoute(
  AppRouteDefinition definition, {
  required RouteTransitionsBuilder transitionsBuilder,
  required Duration duration,
}) {
  return CustomRoute(
    path: definition.path,
    page: definition.page,
    initial: definition.initial,
    transitionsBuilder: transitionsBuilder,
    duration: duration,
    children: definition.children.isEmpty
        ? null
        : buildSlideCustomRoutes(
            definition.children,
            transitionsBuilder: transitionsBuilder,
            duration: duration,
          ),
  );
}

Widget appSlideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const beginOffset = Offset(1, 0);
  const endOffset = Offset.zero;
  final tween = Tween<Offset>(
    begin: beginOffset,
    end: endOffset,
  ).chain(CurveTween(curve: Curves.easeInOut));
  final offsetAnimation = animation.drive(tween);

  return SlideTransition(position: offsetAnimation, child: child);
}
