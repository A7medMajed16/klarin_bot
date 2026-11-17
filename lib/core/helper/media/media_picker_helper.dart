// import 'dart:io';
// import 'dart:ui';

// import 'package:dartz/dartz.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../config/extensions/theme_extensions.dart';
// import '../../theme/app_colors.dart';
// import '../../theme/app_typography.dart';

// /// Selects local media and normalizes recoverable plugin failures to `null`.
// ///
// /// File-picker failures use [Either] because that API exposes an error message.
// class MediaPickerHelper {
//   static const double _defaultMaxFileSizeInMB = 2;
//   static const int _bytesPerMegabyte = 1024 * 1024;

//   final ImagePicker _imagePicker = ImagePicker();
//   final ImageCropper _imageCropper = ImageCropper();

//   Future<Either<String, File?>> getFile({
//     List<String>? allowedExtensions,
//     double? maxFileSizeInMB,
//   }) async {
//     final maxFileSize = maxFileSizeInMB ?? _defaultMaxFileSizeInMB;

//     try {
//       final pickedFile = await FilePicker.pickFile(
//         type: allowedExtensions == null ? FileType.any : FileType.custom,
//         allowedExtensions: allowedExtensions,
//       );

//       if (pickedFile == null) return const Right(null);

//       final pickedFilePath = pickedFile.path;
//       if (pickedFilePath == null) return const Right(null);

//       final pickedFileSize = await pickedFile.length();
//       if (pickedFileSize > _megabytesToBytes(maxFileSize)) {
//         return Left(
//           'custom_widget.max_file_size_exceeded'.tr(
//             args: [maxFileSize.toString()],
//           ),
//         );
//       }

//       return Right(File(pickedFilePath));
//     } on Exception catch (error) {
//       _logMediaPickerError('Picking a file', error);
//       return Left(error.toString());
//     }
//   }

//   Future<File?> imageCropper({
//     required String sourcePath,
//     required String title,
//     CropStyle? cropStyle,
//     CropAspectRatioPresetData? initAspectRatio,
//     BuildContext? context,
//   }) {
//     return _cropImage(
//       sourcePath: sourcePath,
//       context: context,
//       configuration: _CropConfiguration(
//         title: title,
//         style: cropStyle ?? CropStyle.rectangle,
//         initialAspectRatio: initAspectRatio ?? CropAspectRatioPreset.ratio16x9,
//       ),
//     );
//   }

//   Future<File?> getImageFromCamera({
//     required String title,
//     CropStyle? cropStyle,
//     CropAspectRatioPresetData? initAspectRatio,
//     BuildContext? context,
//   }) {
//     return _pickImage(
//       source: ImageSource.camera,
//       context: context,
//       configuration: _CropConfiguration(
//         title: title,
//         style: cropStyle ?? CropStyle.rectangle,
//         initialAspectRatio: initAspectRatio ?? CropAspectRatioPreset.ratio16x9,
//       ),
//     );
//   }

//   Future<File?> getMedia({bool isVideoOnly = false}) async {
//     try {
//       final pickedMedia = isVideoOnly
//           ? await _imagePicker.pickVideo(source: ImageSource.gallery)
//           : await _imagePicker.pickMedia();
//       return pickedMedia == null ? null : File(pickedMedia.path);
//     } on PlatformException catch (error) {
//       _logMediaPickerError('Picking media', error);
//       return null;
//     }
//   }

//   Future<List<File>?> getMultiMedia() async {
//     try {
//       final pickedMedia = await _imagePicker.pickMultipleMedia();
//       return _localFilesFrom(pickedMedia);
//     } on PlatformException catch (error) {
//       _logMediaPickerError('Picking multiple media files', error);
//       return null;
//     }
//   }

//   Future<File?> getImageFromGallery({
//     required String title,
//     CropStyle? cropStyle,
//     CropAspectRatioPresetData? initAspectRatio,
//     BuildContext? context,
//   }) {
//     return _pickImage(
//       source: ImageSource.gallery,
//       context: context,
//       configuration: _CropConfiguration(
//         title: title,
//         style: cropStyle ?? CropStyle.rectangle,
//         initialAspectRatio: initAspectRatio ?? CropAspectRatioPreset.ratio16x9,
//       ),
//     );
//   }

//   Future<List<File>?> getImagesFromGallery(
//     String arabicTitle,
//     String englishTitle,
//     int? limit,
//   ) async {
//     try {
//       if (limit == 1) {
//         final pickedImage = await _imagePicker.pickImage(
//           source: ImageSource.gallery,
//         );
//         return pickedImage == null ? null : [File(pickedImage.path)];
//       }

//       final pickedImages = await _imagePicker.pickMultiImage(limit: limit);
//       return _localFilesFrom(pickedImages);
//     } on PlatformException catch (error) {
//       _logMediaPickerError('Picking images from the gallery', error);
//       return null;
//     }
//   }

//   Future<void> showPhotoPickerBottomSheet({
//     required BuildContext context,
//     required Future<void> Function(File? image) updateImageFunction,
//     required String title,
//     CropStyle? cropStyle,
//     CropAspectRatioPresetData? initAspectRatio,
//     bool isWeb = true,
//   }) async {
//     final configuration = _CropConfiguration(
//       title: title,
//       style: cropStyle ?? CropStyle.rectangle,
//       initialAspectRatio: initAspectRatio ?? CropAspectRatioPreset.ratio16x9,
//     );

//     if (kIsWeb && isWeb) {
//       await _showWebPickerDialog(
//         context: context,
//         configuration: configuration,
//         onImageSelected: updateImageFunction,
//       );
//       return;
//     }

//     await _showMobilePickerSheet(
//       context: context,
//       configuration: configuration,
//       onImageSelected: updateImageFunction,
//     );
//   }

//   Future<File?> _pickImage({
//     required ImageSource source,
//     required _CropConfiguration configuration,
//     BuildContext? context,
//   }) async {
//     try {
//       final pickedImage = await _imagePicker.pickImage(source: source);
//       if (pickedImage == null) return null;
//       if (!kIsWeb && Platform.isWindows) return File(pickedImage.path);
//       if (context != null && !context.mounted) return null;

//       return await _cropImage(
//         sourcePath: pickedImage.path,
//         configuration: configuration,
//         context: context,
//       );
//     } on PlatformException catch (error) {
//       _logMediaPickerError('Picking an image from ${source.name}', error);
//       return null;
//     }
//   }

//   Future<File?> _cropImage({
//     required String sourcePath,
//     required _CropConfiguration configuration,
//     BuildContext? context,
//   }) async {
//     if (kIsWeb && context == null) {
//       _logMediaPickerError(
//         'Cropping an image',
//         ArgumentError.notNull('context'),
//       );
//       return null;
//     }

//     try {
//       final croppedImage = await _imageCropper.cropImage(
//         sourcePath: sourcePath,
//         uiSettings: _cropperUiSettings(configuration, context),
//       );
//       return croppedImage == null ? null : File(croppedImage.path);
//     } on PlatformException catch (error) {
//       _logMediaPickerError('Cropping an image', error);
//       return null;
//     }
//   }

//   List<PlatformUiSettings> _cropperUiSettings(
//     _CropConfiguration configuration,
//     BuildContext? context,
//   ) {
//     final aspectRatioPresets = _aspectRatioPresets(
//       configuration.initialAspectRatio,
//     );

//     return [
//       AndroidUiSettings(
//         toolbarTitle: configuration.title,
//         statusBarLight: false,
//         toolbarColor: AppColors.primerColor,
//         toolbarWidgetColor: Colors.white,
//         lockAspectRatio: true,
//         cropStyle: configuration.style,
//         hideBottomControls: true,
//         initAspectRatio: configuration.initialAspectRatio,
//         aspectRatioPresets: aspectRatioPresets,
//       ),
//       IOSUiSettings(
//         title: configuration.title,
//         doneButtonTitle: 'حفظ',
//         cancelButtonTitle: 'الغاء',
//         aspectRatioLockEnabled: true,
//         aspectRatioPickerButtonHidden: true,
//         cropStyle: configuration.style,
//         aspectRatioLockDimensionSwapEnabled: true,
//         aspectRatioPresets: aspectRatioPresets,
//       ),
//       if (kIsWeb)
//         WebUiSettings(
//           context: context!,
//           background: true,
//           dragMode: WebDragMode.crop,
//           presentStyle: WebPresentStyle.dialog,
//           translations: WebTranslations(
//             title: configuration.title,
//             rotateLeftTooltip: 'custom_widget.rotateLeftTooltip'.tr(),
//             rotateRightTooltip: 'custom_widget.rotateRightTooltip'.tr(),
//             cancelButton: 'custom_widget.cancel'.tr(),
//             cropButton: 'custom_widget.done'.tr(),
//           ),
//         ),
//     ];
//   }

//   Future<void> _showWebPickerDialog({
//     required BuildContext context,
//     required _CropConfiguration configuration,
//     required Future<void> Function(File? image) onImageSelected,
//   }) {
//     return showDialog<void>(
//       context: context,
//       builder: (dialogContext) => _WebImagePickerDialog(
//         title: configuration.title,
//         onTap: () => _pickAndUpdateImage(
//           overlayContext: dialogContext,
//           pickImage: () => _pickImage(
//             source: ImageSource.gallery,
//             configuration: configuration,
//             context: dialogContext,
//           ),
//           onImageSelected: onImageSelected,
//         ),
//       ),
//     );
//   }

//   Future<void> _showMobilePickerSheet({
//     required BuildContext context,
//     required _CropConfiguration configuration,
//     required Future<void> Function(File? image) onImageSelected,
//   }) {
//     return showModalBottomSheet<void>(
//       context: context,
//       useRootNavigator: true,
//       constraints: const BoxConstraints(maxWidth: 500),
//       showDragHandle: false,
//       isScrollControlled: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       builder: (sheetContext) => _ImageSourceBottomSheet(
//         onGalleryTap: () => _pickAndUpdateImage(
//           overlayContext: sheetContext,
//           pickImage: () => _pickImage(
//             source: ImageSource.gallery,
//             configuration: configuration,
//             context: sheetContext,
//           ),
//           onImageSelected: onImageSelected,
//         ),
//         onCameraTap: () => _pickAndUpdateImage(
//           overlayContext: sheetContext,
//           pickImage: () => _pickImage(
//             source: ImageSource.camera,
//             configuration: configuration,
//             context: sheetContext,
//           ),
//           onImageSelected: onImageSelected,
//         ),
//       ),
//     );
//   }

//   Future<void> _pickAndUpdateImage({
//     required BuildContext overlayContext,
//     required Future<File?> Function() pickImage,
//     required Future<void> Function(File? image) onImageSelected,
//   }) async {
//     try {
//       await onImageSelected(await pickImage());
//     } finally {
//       if (overlayContext.mounted) Navigator.of(overlayContext).pop();
//     }
//   }

//   int _megabytesToBytes(double megabytes) {
//     return (megabytes * _bytesPerMegabyte).toInt();
//   }

//   List<File>? _localFilesFrom(List<XFile> pickedFiles) {
//     if (pickedFiles.isEmpty) return null;
//     return pickedFiles
//         .map((pickedFile) => File(pickedFile.path))
//         .toList(growable: false);
//   }

//   List<CropAspectRatioPresetData> _aspectRatioPresets(
//     CropAspectRatioPresetData initialAspectRatio,
//   ) {
//     if (initialAspectRatio == CropAspectRatioPreset.ratio16x9) {
//       return [CropAspectRatioPreset.ratio16x9];
//     }
//     return [CropAspectRatioPreset.ratio16x9, initialAspectRatio];
//   }

//   void _logMediaPickerError(String operation, Object error) {
//     debugPrint('$operation failed: $error');
//   }
// }

// class _CropConfiguration {
//   const _CropConfiguration({
//     required this.title,
//     required this.style,
//     required this.initialAspectRatio,
//   });

//   final String title;
//   final CropStyle style;
//   final CropAspectRatioPresetData initialAspectRatio;
// }

// class _WebImagePickerDialog extends StatelessWidget {
//   const _WebImagePickerDialog({required this.title, required this.onTap});

//   final String title;
//   final Future<void> Function() onTap;

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = context.isDarkMode;

//     return AlertDialog(
//       title: Text(title),
//       backgroundColor: isDarkMode ? AppColors.black0D : AppColors.originalWhite,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       content: SizedBox(
//         width: 400,
//         height: 220,
//         child: InkWell(
//           onTap: onTap,
//           customBorder: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: AppColors.grayE4),
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               spacing: 12,
//               children: [
//                 const Icon(
//                   Icons.upload_file_rounded,
//                   size: 40,
//                   color: AppColors.black0D,
//                 ),
//                 Text(
//                   'custom_widget.drag_and_drop'.tr(),
//                   style: 20.medium.copyWith(color: AppColors.black0D),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ImageSourceBottomSheet extends StatelessWidget {
//   const _ImageSourceBottomSheet({
//     required this.onGalleryTap,
//     required this.onCameraTap,
//   });

//   final Future<void> Function() onGalleryTap;
//   final Future<void> Function() onCameraTap;

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = context.isDarkMode;
//     final foregroundColor = isDarkMode ? AppColors.whiteD5 : AppColors.black0D;

//     return ClipRRect(
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Material(
//           color: (isDarkMode ? AppColors.black0D : AppColors.originalWhite)
//               .withValues(alpha: 0.6),
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//           child: Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               spacing: 5,
//               children: [
//                 _BottomSheetHandle(isDarkMode: isDarkMode),
//                 _PickerActionTile(
//                   icon: Icons.photo_library_rounded,
//                   title: 'custom_widget.gallery'.tr(),
//                   foregroundColor: foregroundColor,
//                   onTap: onGalleryTap,
//                 ),
//                 _PickerActionTile(
//                   icon: Icons.camera_rounded,
//                   title: 'custom_widget.camera'.tr(),
//                   foregroundColor: foregroundColor,
//                   onTap: onCameraTap,
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _BottomSheetHandle extends StatelessWidget {
//   const _BottomSheetHandle({required this.isDarkMode});

//   final bool isDarkMode;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40,
//       height: 4,
//       margin: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: (isDarkMode ? AppColors.originalWhite : AppColors.black1F)
//             .withValues(alpha: isDarkMode ? 0.2 : 0.15),
//         borderRadius: BorderRadius.circular(2),
//       ),
//     );
//   }
// }

// class _PickerActionTile extends StatelessWidget {
//   const _PickerActionTile({
//     required this.icon,
//     required this.title,
//     required this.foregroundColor,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String title;
//   final Color foregroundColor;
//   final Future<void> Function() onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       splashColor: AppColors.primerColor.withValues(alpha: 0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       leading: Icon(icon, color: foregroundColor),
//       title: Text(title, style: 16.semiBold),
//     );
//   }
// }
