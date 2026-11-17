import 'package:equatable/equatable.dart';

class UploadImageParams extends Equatable {
  final String imagePath;
  const UploadImageParams({required this.imagePath});
  @override
  List<Object?> get props => [imagePath];
}

class UploadImagesParams extends Equatable {
  final List<String> imagePaths;
  const UploadImagesParams({required this.imagePaths});
  @override
  List<Object?> get props => [imagePaths];
}

class UploadVideoParams extends Equatable {
  final String videoPath;
  const UploadVideoParams({required this.videoPath});
  @override
  List<Object?> get props => [videoPath];
}

class UploadAudioParams extends Equatable {
  final String audioPath;
  const UploadAudioParams({required this.audioPath});
  @override
  List<Object?> get props => [audioPath];
}

class UploadDocumentParams extends Equatable {
  final String documentPath;
  const UploadDocumentParams({required this.documentPath});
  @override
  List<Object?> get props => [documentPath];
}
