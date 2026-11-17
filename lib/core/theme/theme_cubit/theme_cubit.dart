import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart' show injectable;

import '../../cache/storage/cache_helper.dart';

@injectable
class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(SP.isDarkMode);

  Future<void> toggleDarkMode() async {
    final newValue = !state;
    await SP.setDarkMode(value: newValue);
    emit(newValue);
  }

  Future<void> setDarkMode(bool value) async {
    await SP.setDarkMode(value: value);
    emit(value);
  }

  Brightness get brightness => state ? Brightness.dark : Brightness.light;

  ThemeMode get themeMode => state ? ThemeMode.dark : ThemeMode.light;
}
