import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/auth_session_model.dart';
import 'package:student_marketplace_business_logic/data/models/credentials_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/authenticate_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/authentication/cache_session_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/credentials/check_email_availability_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/sign_up_usecase.dart';

import '../../core/utils/input_validators.dart';
import 'login_view_state.dart';

class LoginViewBloc extends Cubit<LoginViewState> {
  final SignUpUsecase signUpUsecase;
  final CacheSessionUsecase cacheSessionUsecase;
  final AuthenticateUsecase authenticateUsecase;
  final CheckEmailAvailabilityUsecase checkEmailAvailabilityUsecase;

  late bool keepSignedIn = false;
  late bool isEmailCorrect = false;

  LoginViewBloc(
      {required this.checkEmailAvailabilityUsecase,
      required this.authenticateUsecase,
      required this.cacheSessionUsecase,
      required this.signUpUsecase})
      : super(const LoginViewState());

  Future<void> checkIfEmailIsRegistered(CredentialsModel credentials) async {
    emit(state.copyWith(status: LoginPageStatus.emailSubmitting));

    try {
      final result = await checkEmailAvailabilityUsecase(
          CredentialsParams(credentials: credentials));
      if (result is Left) {
        emit(state.copyWith(status: LoginPageStatus.intial));
      } else {
        final success = (result as Right).value;
        emit(state.copyWith(
            status: success
                ? LoginPageStatus.emailSucces
                : LoginPageStatus.intial));
      }
    } catch (_) {
      emit(state.copyWith(status: LoginPageStatus.intial));
    }
  }

  Future<void> changeKeepSignedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    keepSignedIn = !keepSignedIn;

    sharedPrefs.setBool('keepSignedIn', keepSignedIn);
    emit(state.copyWith(keepSignedIn: keepSignedIn));
  }

  Future<void> focusPasswordTextField() async {
    emit(state.copyWith(isEmailCorrect: true));
  }

  Future<void> onPasswordInputChanged(String text) async {
    emit(state.copyWith(isPasswordPrefixActive: text.length > 4));
  }

  Future<void> onEmailInputChanged(String text) async {
    final isEmailValid = checkEmail(text);

    emit(state.copyWith(
        isEmailPrefixActive: isEmailValid && text.isNotEmpty,
        status: LoginPageStatus.intial));
  }

  Future<void> signInUser(CredentialsModel credentials) async {
    emit(state.copyWith(status: LoginPageStatus.passwordSubmitting));
    emit(state);

    try {
      final result = await authenticateUsecase(
          CredentialsParams(credentials: credentials));

      if (result is Left) {
        emit(state.copyWith(status: LoginPageStatus.loginFailed));
      }

      final session = (result as Right).value;

      cacheSessionUsecase(AuthSessionParam(
          session: AuthSessionModel(
              token: session.token, keepPerssistent: keepSignedIn)));

      emit(state.copyWith(status: LoginPageStatus.loginSuccesful));
    } catch (_) {
      emit(state.copyWith(status: LoginPageStatus.loginFailed));
    }
  }
}
