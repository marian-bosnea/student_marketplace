import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_frontend/features/data/models/auth_session_model.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/deauthenticate_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/get_authentication_status_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/get_cached_session_usecase.dart';

import '../../../core/usecases/usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetAuthenticationStatusUsecase authenticationStatusUsecase;
  final DeauthenticateUsecase deauthenticateUsecase;
  final GetCachedSessionUsecase getCachedSessionUsecase;

  AuthCubit(
      {required this.authenticationStatusUsecase,
      required this.getCachedSessionUsecase,
      required this.deauthenticateUsecase})
      : super(AuthInitial());

  Future<void> onAppStarted(BuildContext context) async {
    final eitherSession = await getCachedSessionUsecase(NoParams());

    if (eitherSession is Left) emit(Unauthenticated());

    final session = (eitherSession as Right).value;

    final sharedPrefs = await SharedPreferences.getInstance();

    try {
      final result = await authenticationStatusUsecase(
          AuthSessionParam(session: AuthSessionModel(token: session)));

      final isSignedIn = (result as Right).value;

      final hasCheckedKeepSignedIn = sharedPrefs.getBool('keepSignedIn');

      if (isSignedIn && hasCheckedKeepSignedIn!) {
        emit(Authenticated(token: session.token));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> onSignIn() async {
    try {
      final result = await getCachedSessionUsecase(NoParams());
      if (result is Left) emit(Unauthenticated());

      final session = (result as Right).value;
      emit(Authenticated(token: session.token));
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> signOutUser() async {
    try {
      await deauthenticateUsecase(NoParams());
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }
}
