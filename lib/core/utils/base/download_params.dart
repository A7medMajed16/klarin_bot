import 'package:equatable/equatable.dart';

class DownloadFileParams extends Equatable {
  final String url;
  final String? fileName;

  const DownloadFileParams({required this.url, this.fileName});

  @override
  List<Object?> get props => [url, fileName];
}
