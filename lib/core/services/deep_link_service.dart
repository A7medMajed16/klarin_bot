// import 'dart:developer' show log;

// import 'url_service.dart';

// class DeepLinkService {
//   final AppLinks _appLinks = AppLinks();

//   final DioConsumer dio = getIt<DioConsumer>();

//   void setupDeepLinkHandler() async {
//     // Handle incoming deep links
//     _appLinks.uriLinkStream.listen((Uri? uri) {
//       if (uri != null && uri.pathSegments.contains("dynamic-links")) {
//         handleDeepLink(uri: uri);
//       }
//     });
//   }

//   void handleDeepLink({Uri? uri}) async {
//     DeepLinkModel? deepLinkModel = UrlService.parseDeepLink(uri!);
//     log((deepLinkModel ?? "").toString());
//     // لو shortLink مش فاضي
//     if (deepLinkModel?.shortId?.isNotEmpty ?? false) {
//       try {
//         // ابعت طلب يجيب ال targetUrl بناء على shortLink
//         final response = await dio.get(
//           path: "${deepLinkModel?.deepLinkBase}/${deepLinkModel?.shortId}",
//         );
//         if (response != null && response['targetUrl'] != null) {
//           final String targetUrl = response['targetUrl'];
//           if (targetUrl.isNotEmpty) {
//             _navigateToTarget(targetUrl);
//           } else {
//             _fallbackRedirect();
//           }
//         } else {
//           _fallbackRedirect();
//         }
//       } catch (error, stackTrace) {
//         log('DeepLink error: $error');
//         log('DeepLink stackTrace: $stackTrace');
//         _fallbackRedirect();
//       }
//     }
//   }

//   void _navigateToTarget(String targetUrl) {
//     try {
//       final uri = Uri.tryParse(targetUrl);
//       if (uri == null || uri.pathSegments.length < 2) {
//         _fallbackRedirect();
//         return;
//       }

//       // Extract the last two path segments: routeName and id
//       final routeName = uri.pathSegments[uri.pathSegments.length - 2];
//       final id = uri.pathSegments.last;

//       // Check if user is logged in
//       if (!UserHelper.isLogin()) {
//         appRouter.replaceAll([const LoginScreenRoute()]);
//         return;
//       }

//       if (UserHelper.isUser()) {
//         // Map route name to the correct auto_route screen
//         switch (routeName) {
//           case 'user-product-details':
//             appRouter.push(
//               ProductDetailsScreenRoute(product: ProductModel(), id: id),
//             );
//             break;
//           case 'user-feature-details':
//             appRouter.push(
//               FeatureDetailsScreenRoute(feature: UserFeatureModel(), id: id),
//             );
//             break;
//           default:
//             _fallbackRedirect();
//         }
//       }
//     } catch (e, stackTrace) {
//       log('DeepLink navigation error: $e');
//       log('DeepLink navigation stackTrace: $stackTrace');
//       _fallbackRedirect();
//     }
//   }

//   void _fallbackRedirect() {
//     if (UserHelper.isLogin()) {
//       appRouter.replaceAll([const UserLayoutScreenRoute()]);
//     } else {
//       appRouter.replaceAll([const LoginScreenRoute()]);
//     }
//   }
// }
