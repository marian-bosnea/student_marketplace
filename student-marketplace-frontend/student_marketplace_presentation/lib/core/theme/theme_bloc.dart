import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_presentation/core/theme/theme_state.dart';

class ThemeBloc extends Cubit<ThemeState> {
  ThemeBloc() : super(const ThemeState());

  void setTheme(ThemeMode themeMode) =>
      emit(state.copyWith(themeMode: themeMode));
}
