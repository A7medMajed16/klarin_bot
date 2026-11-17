import 'dart:developer' show log;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_logger.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      AppLogger.info('onCreate -- ${bloc.runtimeType}', tag: 'Bloc');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (!kDebugMode) return;

    final currentFields = _parseTopLevelFields(
      change.currentState.toString(),
    );
    final nextFields = _parseTopLevelFields(
      change.nextState.toString(),
    );

    if (currentFields != null && nextFields != null) {
      final lines = <String>[
        '${bloc.runtimeType}[',
        for (final key in nextFields.keys)
          '==$key: current ${_extractStatus(currentFields[key])} next ${_extractStatus(nextFields[key])}',
        ']',
      ];

      const colorCode = '95';
      final colored = lines
          .map((l) => '\x1B[${colorCode}m$l\x1B[0m')
          .join('\n');
      log(colored);
    } else {
      AppLogger.debug('${bloc.runtimeType} changed', tag: 'Bloc');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      AppLogger.error(
        'onError -- ${bloc.runtimeType}',
        error: error,
        stackTrace: stackTrace,
        tag: 'Bloc',
      );
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      AppLogger.info('onClose -- ${bloc.runtimeType}', tag: 'Bloc');
    }
  }

  /// Extracts status name from a StateStatus toString.
  /// Handles both:
  /// - Clean: "UpdateUi" (after build_runner regeneration)
  /// - Verbose: "StateStatus.updateUi(data: 0, time: null)"
  String _extractStatus(String? value) {
    if (value == null) return '?';
    final parenIdx = value.indexOf('(');
    if (parenIdx != -1) {
      final beforeParen = value.substring(0, parenIdx);
      final dotIdx = beforeParen.lastIndexOf('.');
      if (dotIdx != -1) return beforeParen.substring(dotIdx + 1);
    }
    return value;
  }

  /// Parses top-level fields from Freezed toString, respecting nesting.
  Map<String, String>? _parseTopLevelFields(String stateStr) {
    final openParen = stateStr.indexOf('(');
    final closeParen = stateStr.lastIndexOf(')');
    if (openParen == -1 ||
        closeParen == -1 ||
        openParen >= closeParen) {
      return null;
    }

    final content = stateStr.substring(openParen + 1, closeParen);
    final fields = <String, String>{};
    int depth = 0;
    int segmentStart = 0;

    for (int i = 0; i <= content.length; i++) {
      if (i == content.length || (content[i] == ',' && depth == 0)) {
        final segment = content.substring(segmentStart, i).trim();
        final colonIdx = segment.indexOf(': ');
        if (colonIdx != -1) {
          fields[segment.substring(0, colonIdx).trim()] = segment
              .substring(colonIdx + 2)
              .trim();
        }
        segmentStart = i + 1;
      } else if (content[i] == '(' ||
          content[i] == '<' ||
          content[i] == '[') {
        depth++;
      } else if (content[i] == ')' ||
          content[i] == '>' ||
          content[i] == ']') {
        depth--;
      }
    }

    return fields.isEmpty ? null : fields;
  }
}
