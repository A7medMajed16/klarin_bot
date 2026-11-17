// stub_dropzone.dart - Stub file for non-web platforms
import 'package:material_ui/material_ui.dart';

// Stub implementations for non-web platforms
class DropzoneView extends StatelessWidget {
  final DragOperation? operation;
  final CursorType? cursor;
  final Function(dynamic)? onCreated;
  final VoidCallback? onHover;
  final VoidCallback? onLeave;
  final Function(dynamic)? onDrop;

  const DropzoneView({
    super.key,
    this.operation,
    this.cursor,
    this.onCreated,
    this.onHover,
    this.onLeave,
    this.onDrop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(); // Empty container for non-web
  }
}

class DropzoneViewController {
  Future<String> getFileMIME(dynamic event) async => '';
  Future<List<int>> getFileData(dynamic event) async => [];
  Future<String> getFilename(dynamic event) async => '';
}

enum DragOperation { copy }

enum CursorType { pointer }
