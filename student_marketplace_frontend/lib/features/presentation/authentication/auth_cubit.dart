import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/user/get_auth_token_usecase.dart';
import '../../domain/usecases/user/is_signed_in_usecase.dart';
import '../../domain/usecases/user/sign_out_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IsSignedInUsecase isSignedInUsecase;
  final SignOutUsecase signOutUsecase;
  final GetAuthToken getAuthTokenUsecase;

  AuthCubit(
      {required this.isSignedInUsecase,
      required this.signOutUsecase,
      required this.getAuthTokenUsecase})
      : super(AuthInitial());

  Future<void> onAppStarted(BuildContext context) async {
    final token = (await getAuthTokenUsecase(NoParams())).getOrElse(() => '');

    if (token != '') {
      try {
        bool isSignIn =
            (await isSignedInUsecase(UserParam(user: UserModel(id: token))))
                .getOrElse(() => false);

        if (isSignIn) {
          emit(Authenticated(token: token));
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
      final token = (await getAuthTokenUsecase(NoParams())).getOrElse(() => '');
      if (token != '') {
        emit(Authenticated(token: token));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {}
  }

  Future<void> signOutUser() async {
    try {
      final token = (await getAuthTokenUsecase(NoParams())).getOrElse(() => '');
      if (token != '') {
        await signOutUsecase(UserParam(user: UserModel(id: token)));
        emit(Unauthenticated());
      }
      emit(Unauthenticated());
    } catch (_) {
      emit(Unauthenticated());
    }
  }
}
