//! OPTIONAL "location": requires geolocator, geocoding, latlong2, map_launcher.
//! Enable it in Automation_dart/init_project_folders.dart (optionalFeatures).
//#optional:location
// import 'dart:io' show HttpClient, HttpHeaders;
// import 'dart:math';

// import 'package:dartz/dartz.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:material_ui/material_ui.dart'
//     show showModalBottomSheet, Colors, BuildContext, Locale;
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart' show LatLng;
// import 'package:map_launcher/map_launcher.dart'
//     show LocationCoords, MapApp, MapLauncher, TravelMode;

// import '../../api/errors/failure.dart';
// import '../../common/widgets/sheets/map_chooser_bottom_sheet.dart';
// import '../core/app_logger.dart';

// class LocationHelper {
//   static final RegExp _urlPattern = RegExp(
//     r'https?://[^\s<>"{}|\\^`\[\]]+',
//     caseSensitive: false,
//   );

//   static final RegExp _rawCoordsPattern = RegExp(
//     r'^\s*(-?\d{1,3}(?:\.\d+)?)\s*,\s*(-?\d{1,3}(?:\.\d+)?)\s*$',
//   );

//   // Separators between lat/lng in paths/queries: comma, plus, whitespace
//   static const String _coordSep = r'[,+\s]+';

//   static final List<({RegExp pattern, bool reversed})> _coordPatterns = [
//     // Google: @lat,lng or /@lat,lng,zoom
//     (
//       pattern: RegExp(r'@(-?\d{1,3}(?:\.\d+)?),(-?\d{1,3}(?:\.\d+)?)'),
//       reversed: false,
//     ),
//     // Google place data: !3dlat!4dlng
//     (
//       pattern: RegExp(r'!3d(-?\d{1,3}(?:\.\d+)?)!4d(-?\d{1,3}(?:\.\d+)?)'),
//       reversed: false,
//     ),
//     // Google short-link destination: /maps/search/lat,+lng
//     (
//       pattern: RegExp(
//         r'/maps/search/(-?\d{1,3}(?:\.\d+)?)'
//         '$_coordSep'
//         r'(-?\d{1,3}(?:\.\d+)?)',
//         caseSensitive: false,
//       ),
//       reversed: false,
//     ),
//     // q=lat,lng / query=lat,lng (comma or +)
//     (
//       pattern: RegExp(
//         r'[?&](?:q|query)=(-?\d{1,3}(?:\.\d+)?)'
//         '$_coordSep'
//         r'(-?\d{1,3}(?:\.\d+)?)',
//         caseSensitive: false,
//       ),
//       reversed: false,
//     ),
//     // Apple place short-link destination: coordinate=lat,lng
//     (
//       pattern: RegExp(
//         r'[?&]coordinate=(-?\d{1,3}(?:\.\d+)?),(-?\d{1,3}(?:\.\d+)?)',
//         caseSensitive: false,
//       ),
//       reversed: false,
//     ),
//     // ll=lat,lng (Apple Maps / Google)
//     (
//       pattern: RegExp(r'[?&]ll=(-?\d{1,3}(?:\.\d+)?),(-?\d{1,3}(?:\.\d+)?)'),
//       reversed: false,
//     ),
//     // center=lat,lng
//     (
//       pattern: RegExp(
//         r'[?&]center=(-?\d{1,3}(?:\.\d+)?),(-?\d{1,3}(?:\.\d+)?)',
//       ),
//       reversed: false,
//     ),
//     // geo:lat,lng
//     (
//       pattern: RegExp(r'geo:(-?\d{1,3}(?:\.\d+)?),(-?\d{1,3}(?:\.\d+)?)'),
//       reversed: false,
//     ),
//     // OSM mlat + mlon
//     (
//       pattern: RegExp(
//         r'[?&]mlat=(-?\d{1,3}(?:\.\d+)?).*?[?&]mlon=(-?\d{1,3}(?:\.\d+)?)',
//         caseSensitive: false,
//       ),
//       reversed: false,
//     ),
//     (
//       pattern: RegExp(
//         r'[?&]mlon=(-?\d{1,3}(?:\.\d+)?).*?[?&]mlat=(-?\d{1,3}(?:\.\d+)?)',
//         caseSensitive: false,
//       ),
//       reversed: true,
//     ),
//   ];

//   static Future<Either<Failure, Position>> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     permission = await Geolocator.checkPermission();
//     AppLogger.error(permission.toString());
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Left(
//           LocationFailure(
//             errorMessage: "location.location_permissions_denied".tr(),
//           ),
//         );
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Left(
//         LocationFailure(
//           errorMessage: "location.location_permissions_denied_forever".tr(),
//         ),
//       );
//     }

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return Left(
//         LocationFailure(errorMessage: "location.enable_location_service".tr()),
//       );
//     }

//     try {
//       final position = await Geolocator.getCurrentPosition();
//       return Right(position);
//     } catch (e) {
//       return Left(
//         LocationFailure(
//           errorMessage: "location.failed_to_get_location".tr(
//             args: [e.toString()],
//           ),
//         ),
//       );
//     }
//   }

//   static Future<String> getAddressTitle(double lat, double lng) async {
//     try {
//       final geocoding = Geocoding(locale: const Locale('ar'));
//       final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         return "${place.administrativeArea}, ${place.locality}, ${place.street}";
//       }
//       return "";
//     } catch (e) {
//       return "";
//     }
//   }

//   /// Parses a maps link (or raw "lat,lng") into [LatLng].
//   /// Resolves shortened Google / Apple links when coordinates
//   /// are not embedded in the short URL itself.
//   static Future<LatLng?> parseLocationFromLink(String input) async {
//     final trimmed = input.trim();
//     if (trimmed.isEmpty) return null;

//     final raw = _parseRawCoords(trimmed);
//     if (raw != null) return raw;

//     final url = _extractUrl(trimmed) ?? trimmed;
//     final direct = _extractCoords(url);
//     if (direct != null) return direct;

//     if (_needsRedirectResolve(url)) {
//       final resolved = await _resolveRedirects(url);
//       if (resolved != null) {
//         final fromUrl = _extractCoords(resolved);
//         if (fromUrl != null) return fromUrl;
//       }
//     }

//     return null;
//   }

//   static LatLng? _parseRawCoords(String text) {
//     final match = _rawCoordsPattern.firstMatch(text);
//     if (match == null) return null;
//     return _toLatLng(match.group(1)!, match.group(2)!);
//   }

//   static String? _extractUrl(String text) {
//     final match = _urlPattern.firstMatch(text);
//     if (match == null) return null;
//     return match.group(0)?.replaceAll(RegExp(r'[.,;:!?)]+$'), '');
//   }

//   /// Short links that hide lat/lng until redirects (Google share, Apple place).
//   static bool _needsRedirectResolve(String url) {
//     final lower = url.toLowerCase();
//     return lower.contains('maps.app.goo.gl') ||
//         lower.contains('goo.gl/maps') ||
//         lower.contains('g.co/maps') ||
//         lower.contains('maps.google') ||
//         lower.contains('google.com/maps') ||
//         lower.contains('maps.apple') ||
//         lower.contains('bit.ly') ||
//         lower.contains('tinyurl.com');
//   }

//   static LatLng? _extractCoords(String text) {
//     String decoded;
//     try {
//       decoded = Uri.decodeFull(text);
//     } catch (_) {
//       decoded = text;
//     }

//     for (final entry in _coordPatterns) {
//       final match = entry.pattern.firstMatch(decoded);
//       if (match == null) continue;

//       if (entry.reversed) {
//         return _toLatLng(match.group(2)!, match.group(1)!);
//       }
//       return _toLatLng(match.group(1)!, match.group(2)!);
//     }

//     return null;
//   }

//   static LatLng? _toLatLng(String latStr, String lngStr) {
//     final lat = double.tryParse(latStr);
//     final lng = double.tryParse(lngStr);
//     if (lat == null || lng == null) return null;
//     if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
//     return LatLng(lat, lng);
//   }

//   static Future<String?> _resolveRedirects(String url) async {
//     final client = HttpClient();
//     try {
//       var current = Uri.parse(url);
//       for (var i = 0; i < 10; i++) {
//         final request = await client.getUrl(current);
//         request.followRedirects = false;
//         // Mobile UA — short map hosts redirect more reliably
//         request.headers.set(
//           HttpHeaders.userAgentHeader,
//           'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) '
//           'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 '
//           'Mobile/15E148 Safari/604.1',
//         );
//         request.headers.set(HttpHeaders.acceptHeader, 'text/html,*/*');
//         final response = await request.close();
//         await response.drain<void>();

//         if (response.isRedirect ||
//             response.statusCode == 301 ||
//             response.statusCode == 302 ||
//             response.statusCode == 303 ||
//             response.statusCode == 307 ||
//             response.statusCode == 308) {
//           final location = response.headers.value(HttpHeaders.locationHeader);
//           if (location == null || location.isEmpty) break;
//           current = current.resolve(location);
//           // Stop early when lat/lng already appear in the Location header
//           if (_extractCoords(current.toString()) != null) {
//             return current.toString();
//           }
//           continue;
//         }

//         return current.toString();
//       }
//       return current.toString();
//     } catch (e) {
//       AppLogger.error(e.toString(), tag: 'LocationHelper.parseLink');
//       return null;
//     } finally {
//       client.close(force: true);
//     }
//   }

//   /// Map apps offered for navigation (opt-in for tree-shaking).
//   static const List<MapApp> _navigationMaps = <MapApp>[
//     MapApp.apple,
//     MapApp.google,
//     MapApp.waze,
//   ];

//   static Future<void> openNavigationToDestination(
//     BuildContext context, {
//     required double destLat,
//     required double destLng,
//     String destTitle = 'Destination',
//   }) async {
//     try {
//       final destination = LocationCoords(destLat, destLng, title: destTitle);
//       final request = MapLauncher.directions(
//         destination,
//         mode: TravelMode.driving,
//       );
//       final availableMaps = await request.getSupportedMaps(_navigationMaps);

//       if (availableMaps.isEmpty) return;

//       if (availableMaps.length == 1) {
//         await availableMaps.first.show();
//         return;
//       }

//       if (context.mounted) {
//         showModalBottomSheet(
//           context: context,
//           backgroundColor: Colors.transparent,
//           isScrollControlled: true,
//           builder: (_) => MapChooserBottomSheet(availableMaps: availableMaps),
//         );
//       }
//     } catch (e) {
//       AppLogger.error(e.toString(), tag: 'LocationHelper');
//     }
//   }

//   static double calculateDistance(List<double> point1, List<double> point2) {
//     if (point1.length != 2 || point2.length != 2) {
//       throw ArgumentError('Both points must contain exactly two coordinates.');
//     }

//     const double earthRadius = 6371;

//     double toRadians(double degree) => degree * (3.141592653589793 / 180);

//     double lat1 = toRadians(point1[0]);
//     double lon1 = toRadians(point1[1]);
//     double lat2 = toRadians(point2[0]);
//     double lon2 = toRadians(point2[1]);

//     double dLat = lat2 - lat1;
//     double dLon = lon2 - lon1;

//     double a =
//         (sin(dLat / 2) * sin(dLat / 2)) +
//         cos(lat1) * cos(lat2) * (sin(dLon / 2) * sin(dLon / 2));
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//     return double.parse((earthRadius * c).toStringAsFixed(2));
//   }
// }
//#end-optional:location
