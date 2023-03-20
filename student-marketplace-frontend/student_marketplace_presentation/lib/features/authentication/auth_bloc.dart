import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/auth_session_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/deauthenticate_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/get_authentication_status_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/get_cached_session_usecase.dart';

import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  final GetAuthenticationStatusUsecase authenticationStatusUsecase;
  final DeauthenticateUsecase deauthenticateUsecase;
  final GetCachedSessionUsecase getCachedSessionUsecase;

  AuthBloc(
      {required this.authenticationStatusUsecase,
      required this.getCachedSessionUsecase,
      required this.deauthenticateUsecase})
      : super(const AuthState());

  Future<void> onAppStarted(BuildContext context) async {
    final eitherSession = await getCachedSessionUsecase(NoParams());

    if (eitherSession is Left) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }

    final session = (eitherSession as Right).value;

    try {
      final result = await authenticationStatusUsecase(AuthSessionParam(
          session:
              AuthSessionModel(token: session.token, keepPerssistent: true)));

      final isSignedIn = (result as Right).value;

      final hasCheckedKeepSignedIn = session.keepPerssistent;

      if (isSignedIn && hasCheckedKeepSignedIn!) {
        emit(state.copyWith(
            token: session.token, status: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> onSignIn() async {
    try {
      final result = await getCachedSessionUsecase(NoParams());
      if (result is Left) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }

      final session = (result as Right).value;

      emit(state.copyWith(
          token: session.token, status: AuthStatus.authenticated));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> signOutUser(BuildContext context) async {
    try {
      await deauthenticateUsecase(NoParams());
      emit(state.copyWith(status: AuthStatus.unauthenticated));

      Navigator.of(context).popAndPushNamed('/');
    } catch (e) {
      //   emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }
}
