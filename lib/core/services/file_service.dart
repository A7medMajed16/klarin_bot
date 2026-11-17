import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

enum FileTypes {
  image(mimeType: "image/jpeg", extensions: ["jpg", "jpeg", "png"]),
  video(mimeType: "video/mp4", extensions: ["mp4", "avi", "mov"]),
  pdf(mimeType: "application/pdf", extensions: ["pdf"]),
  unknown();

  final String? mimeType;
  final List<String>? extensions;

  const FileTypes({this.mimeType, this.extensions});
}

class FileService {
  static const int _bytesPerKilobyte = 1024;
  static const int _bytesPerMegabyte = _bytesPerKilobyte * 1024;

  Future<File?> compressImage(
    File file, {
    int quality = 80,
    int? maxBytes,
    int maxWidth = 1920,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      var decodedImage = img.decodeImage(bytes);

      if (decodedImage == null) return null;

      if (decodedImage.width > maxWidth || decodedImage.height > maxWidth) {
        final scale =
            maxWidth / math.max(decodedImage.width, decodedImage.height);
        decodedImage = img.copyResize(
          decodedImage,
          width: (decodedImage.width * scale).round(),
          height: (decodedImage.height * scale).round(),
          interpolation: img.Interpolation.linear,
        );
      }

      var currentQuality = quality.clamp(10, 100);
      List<int> compressedBytes = img.encodeJpg(
        decodedImage,
        quality: currentQuality,
      );

      if (maxBytes != null) {
        while (compressedBytes.length > maxBytes && currentQuality > 20) {
          currentQuality = math.max(20, currentQuality - 15);
          compressedBytes = img.encodeJpg(
            decodedImage,
            quality: currentQuality,
          );
        }
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = path.basenameWithoutExtension(file.path);
      final newPath = path.join(
        tempDir.path,
        '${fileName}_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final compressedFile = File(newPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      return null;
    }
  }

  static String formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '';

    if (bytes < _bytesPerMegabyte) {
      final kb = bytes / _bytesPerKilobyte;
      return '${kb.toStringAsFixed(kb >= 10 ? 0 : 1)} KB';
    }

    final mb = bytes / _bytesPerMegabyte;
    return '${mb.toStringAsFixed(1)} MB';
  }

  static String getFileName(String path) {
    return path.split('/').last;
  }

  static String getFileExtension(String path) {
    return path.split('.').last;
  }

  static FileTypes getFileType(String path) {
    final extension = getFileExtension(path);
    if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
      return FileTypes.image;
    } else if (extension == 'mp4' || extension == 'avi' || extension == 'mov') {
      return FileTypes.video;
    } else if (extension == 'pdf') {
      return FileTypes.pdf;
    }
    return FileTypes.unknown;
  }
}
