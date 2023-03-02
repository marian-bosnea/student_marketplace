import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_frontend/features/data/models/auth_session_model.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/get_cached_session_usecase.dart';

import '../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/user/is_signed_in_usecase.dart';
import '../../domain/usecases/user/sign_out_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignedInUsecase isSignedInUsecase;
  final SignOutUsecase signOutUsecase;
  final GetCachedSessionUsecase getAuthTokenUsecase;

  AuthCubit(
      {required this.isSignedInUsecase,
      required this.signOutUsecase,
      required this.getAuthTokenUsecase})
      : super(AuthInitial());

  Future<void> onAppStarted(BuildContext context) async {
    final session = (await getAuthTokenUsecase(NoParams()))
        .getOrElse(() => AuthSessionModel(token: ''));

    if (session.token != '') {
      try {
        bool isSignIn = (await isSignedInUsecase(
                UserParam(user: UserModel(authToken: session.token))))
            .getOrElse(() => false);

        final sharedPrefs = await SharedPreferences.getInstance();
        final hasCheckedKeepSignedIn = sharedPrefs.getBool('keepSignedIn');
        if (isSignIn && hasCheckedKeepSignedIn!) {
          emit(Authenticated(token: session.token));
        } else {
          emit(Unauthenticated());
        }
      } catch (_) {
        emit(Unauthenticated());
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> onSignIn() async {
    try {
      final session = (await getAuthTokenUsecase(NoParams()))
          .getOrElse(() => AuthSessionModel(token: ''));
      if (session.token != '') {
        emit(Authenticated(token: session.token));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {}
  }

  Future<void> signOutUser() async {
    try {
      final session = (await getAuthTokenUsecase(NoParams()))
          .getOrElse(() => AuthSessionModel(token: ''));
      if (session.token != '') {
        await signOutUsecase(
            UserParam(user: UserModel(authToken: session.token)));
        emit(Unauthenticated());
      }
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }
}
