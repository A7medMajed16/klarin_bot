import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

extension FormExtensions on GlobalKey<FormState> {
  /// Validates the form and scrolls to the first field with an error.
  /// Also triggers a heavy haptic vibration feedback on failure.
  /// Returns [true] if the form is valid, [false] otherwise.
  bool scrollToFirstError() {
    final FormState? formState = currentState;
    if (formState == null) return true;

    final bool isValid = formState.validate();

    if (!isValid) {
      // Trigger heavy feedback for error
      HapticFeedback.heavyImpact();

      final BuildContext context = formState.context;
      bool foundFirstError = false;

      void findFirstErrorRecursive(Element element) {
        if (foundFirstError) return;

        if (element.widget is FormField) {
          final FormFieldState? state =
              (element as StatefulElement).state as FormFieldState?;
          if (state != null && state.hasError) {
            foundFirstError = true;
            Scrollable.ensureVisible(
              element,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: 0.5, // Center the field in the viewport
            );
            return;
          }
        }
        element.visitChildren(findFirstErrorRecursive);
      }

      context.visitChildElements(findFirstErrorRecursive);
    }
    return isValid;
  }
}
