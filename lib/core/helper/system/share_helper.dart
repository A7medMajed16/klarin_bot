// import 'dart:developer';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';

// class ShareHelper {
//   static Future<void> share({
//     String? text,
//     String? subject,
//     String? imageUrl,
//     Uint8List? imageBytes,
//     String? imageName,
//     List<String>? filePaths,
//     Rect? sharePositionOrigin,
//     bool shareImageAsUrl = false,
//   }) async {
//     try {
//       final hasText = text != null && text.isNotEmpty;
//       final hasImageUrl = imageUrl != null && imageUrl.isNotEmpty;
//       final hasImageBytes = imageBytes != null && imageBytes.isNotEmpty;
//       final hasFiles = filePaths != null && filePaths.isNotEmpty;

//       if (!hasText && !hasImageUrl && !hasImageBytes && !hasFiles) {
//         log('Nothing to share - all parameters are null');
//         return;
//       }

//       if (kIsWeb) {
//         if (hasImageUrl) {
//           final shareText = hasText ? '$text\n\n$imageUrl' : imageUrl;
//           await SharePlus.instance.share(
//             ShareParams(
//               text: shareText,
//               subject: subject,
//               sharePositionOrigin: sharePositionOrigin,
//             ),
//           );
//         } else if (hasText) {
//           await SharePlus.instance.share(
//             ShareParams(
//               text: text,
//               subject: subject,
//               sharePositionOrigin: sharePositionOrigin,
//             ),
//           );
//         } else {
//           await SharePlus.instance.share(
//             ShareParams(
//               text: 'Shared content',
//               subject: subject,
//               sharePositionOrigin: sharePositionOrigin,
//             ),
//           );
//         }
//       } else {
//         if (shareImageAsUrl && hasImageUrl && hasText) {
//           final shareText = '$text\n\n$imageUrl';
//           await SharePlus.instance.share(
//             ShareParams(
//               text: shareText,
//               subject: subject,
//               sharePositionOrigin: sharePositionOrigin,
//             ),
//           );
//           return;
//         }

//         final List<XFile> xFiles = [];

//         if (hasImageUrl) {
//           try {
//             final dio = Dio();
//             final response = await dio.get<List<int>>(
//               imageUrl,
//               options: Options(responseType: ResponseType.bytes),
//             );

//             if (response.statusCode == 200 && response.data != null) {
//               final bytes = Uint8List.fromList(response.data!);
//               final temp = await getTemporaryDirectory();

//               var fileName = imageUrl.split('/').last.split('?').first;
//               if (!fileName.contains('.')) {
//                 final contentType = response.headers.value('content-type');
//                 String extension = 'jpg';

//                 if (contentType != null) {
//                   if (contentType.contains('png')) {
//                     extension = 'png';
//                   } else if (contentType.contains('jpeg') ||
//                       contentType.contains('jpg')) {
//                     extension = 'jpg';
//                   } else if (contentType.contains('gif')) {
//                     extension = 'gif';
//                   } else if (contentType.contains('webp')) {
//                     extension = 'webp';
//                   }
//                 }

//                 fileName =
//                     'shared_image_${DateTime.now().millisecondsSinceEpoch}.$extension';
//               }

//               final file = File('${temp.path}/$fileName');
//               await file.writeAsBytes(bytes);
//               xFiles.add(
//                 XFile(
//                   file.path,
//                   mimeType: _getMimeType(fileName),
//                   name: fileName,
//                 ),
//               );
//             }
//           } catch (e) {
//             log('Error downloading image from URL: $e');
//           }
//         }

//         if (hasImageBytes) {
//           try {
//             final temp = await getTemporaryDirectory();
//             var fileName =
//                 imageName ??
//                 'shared_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

//             if (!fileName.contains('.')) {
//               fileName = '$fileName.jpg';
//             }

//             final file = File('${temp.path}/$fileName');
//             await file.writeAsBytes(imageBytes);
//             xFiles.add(
//               XFile(
//                 file.path,
//                 mimeType: _getMimeType(fileName),
//                 name: fileName,
//               ),
//             );
//           } catch (e) {
//             log('Error saving image bytes: $e');
//           }
//         }

//         if (hasFiles) {
//           for (final filePath in filePaths) {
//             try {
//               if (await File(filePath).exists()) {
//                 final fileName = filePath.split('/').last;
//                 xFiles.add(
//                   XFile(
//                     filePath,
//                     mimeType: _getMimeType(fileName),
//                     name: fileName,
//                   ),
//                 );
//               }
//             } catch (e) {
//               log('Error adding file: $e');
//             }
//           }
//         }

//         if (xFiles.isNotEmpty && hasText) {
//           await SharePlus.instance.share(
//             ShareParams(
//               files: xFiles,
//               text: text,
//               subject: subject,
//               sharePositionOrigin: sharePositionOrigin,
//             ),
//           );
//         } else if (xFiles.isNotEmpty) {
//           await SharePlus.instance.share(
//             ShareParams(
//               files: xFiles,
//               subject: subject,
//               sharePositionOrigin: sharePositionOrigin,
//             ),
//           );
//         } else if (hasText) {
//           await SharePlus.instance.share(
//             ShareParams(
//               text: text,
//               subject: subject,
//               sharePositionOrigin: sharePositionOrigin,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       log('Error sharing: $e');
//       rethrow;
//     }
//   }

//   static String _getMimeType(String fileName) {
//     final extension = fileName.split('.').last.toLowerCase();
//     switch (extension) {
//       case 'jpg':
//       case 'jpeg':
//         return 'image/jpeg';
//       case 'png':
//         return 'image/png';
//       case 'gif':
//         return 'image/gif';
//       case 'webp':
//         return 'image/webp';
//       case 'bmp':
//         return 'image/bmp';
//       case 'svg':
//         return 'image/svg+xml';
//       default:
//         return 'image/jpeg';
//     }
//   }

//   static Rect? getSharePositionOrigin(BuildContext context) {
//     final box = context.findRenderObject() as RenderBox?;
//     if (box != null) {
//       return box.localToGlobal(Offset.zero) & box.size;
//     }
//     return null;
//   }

//   static Future<bool> copyToClipboard(String text) async {
//     try {
//       if (text.isEmpty) {
//         log('Cannot copy empty text to clipboard');
//         return false;
//       }

//       await Clipboard.setData(ClipboardData(text: text));
//       log('Text copied to clipboard successfully');
//       return true;
//     } catch (e) {
//       log('Error copying to clipboard: $e');
//       return false;
//     }
//   }
// }
