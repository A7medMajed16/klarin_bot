class UrlService {
  static bool isValidSongUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      final extension = uri.path.split('.').last.toLowerCase();
      final domain = uri.host.toLowerCase();

      if ([
        'mp3',
        'wav',
        'm4a',
        'aac',
        'flac',
        'ogg',
        'wma',
      ].contains(extension)) {
        return true;
      }

      if (domain.contains('music.youtube.com') ||
          domain.contains('youtube.com')) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  static DeepLinkModel? parseDeepLink(Uri uri) {
    try {
      if (!uri.hasScheme || uri.host.isEmpty) return null;

      final pathSegments = uri.pathSegments
          .where((s) => s.isNotEmpty)
          .toList();
      if (pathSegments.isEmpty) return null;

      // Last segment is the shortId
      final shortId = pathSegments.last;

      // Build the base URL without the shortId
      final baseUrl = '${uri.scheme}://${uri.host}';
      final remainingSegments = pathSegments.sublist(
        0,
        pathSegments.length - 1,
      );

      String deepLinkBase;

      if (remainingSegments.contains('v2')) {
        // Replace 'v2' with 'short-code'
        final updated = remainingSegments
            .map((s) => s == 'v2' ? 'short-code' : s)
            .toList();
        deepLinkBase = '$baseUrl/${updated.join('/')}';
      } else if (remainingSegments.contains('dynamic-links')) {
        // Has 'dynamic-links' but no 'v2', just append 'short-code'
        deepLinkBase =
            '$baseUrl/${remainingSegments.join('/')}/short-code';
      } else {
        // No 'dynamic-links' at all, append 'dynamic-links/short-code'
        deepLinkBase =
            '$baseUrl/${remainingSegments.join('/')}/dynamic-links/short-code';
      }

      return DeepLinkModel(
        shortId: shortId,
        deepLinkBase: deepLinkBase,
      );
    } catch (e) {
      return null;
    }
  }

  static bool isValidVideoUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      final extension = uri.path.split('.').last.toLowerCase();
      final domain = uri.host.toLowerCase();

      if ([
        'mp4',
        'mov',
        'avi',
        'wmv',
        'flv',
        'mkv',
        'webm',
      ].contains(extension)) {
        return true;
      }

      if (domain.contains('youtube.com') ||
          domain.contains('youtu.be') ||
          domain.contains('vimeo.com')) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}

class DeepLinkModel {
  String? shortId;
  String? deepLinkBase;

  DeepLinkModel({this.shortId, this.deepLinkBase});

  @override
  String toString() {
    return 'DeepLinkModel(shortId: $shortId, deepLinkBase: $deepLinkBase)';
  }
}
