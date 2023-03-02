import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_frontend/features/data/models/auth_session_model.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/authenticate_usecase.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/credentials/check_email_availability_usecase.dart';
import '../../../core/input_validators.dart';
import '../../../core/usecases/usecase.dart';
import '../../data/models/credentials_model.dart';
import '../../domain/usecases/user/sign_up_usecase.dart';
import 'login_page_state.dart';
import '../../data/models/user_model.dart';

class LoginCubit extends Cubit<LoginPageState> {
  final SignUpUsecase signUpUsecase;
  final AuthenticateUsecase authenticateUsecase;
  final CheckEmailAvailabilityUsecase checkEmailAvailabilityUsecase;

  late bool keepSignedIn = false;
  late bool isEmailCorrect = false;

  late LoginPageState state = LoginPageState();

  LoginCubit(
      {required this.checkEmailAvailabilityUsecase,
      required this.authenticateUsecase,
      required this.signUpUsecase})
      : super(const LoginPageState());

  Future<void> checkIfEmailIsRegistered(CredentialsModel credentials) async {
    state = state.copyWith(status: LoginPageStatus.emailSubmitting);
    emit(state);

    try {
      final result = await checkEmailAvailabilityUsecase(
          CredentialsParams(credentials: credentials));

      var a = 0;
      if (result is Left) {
        state = state.copyWith(status: LoginPageStatus.intial);
      } else {
        final success = (result as Right).value;
        state = state.copyWith(
            status:
                success ? LoginPageStatus.emailSucces : LoginPageStatus.intial);
      }
    } catch (_) {
      state = state.copyWith(status: LoginPageStatus.intial);
    }
    emit(state);
  }

  Future<void> changeKeepSignedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    keepSignedIn = !keepSignedIn;

    sharedPrefs.setBool('keepSignedIn', keepSignedIn);
    state = state.copyWith(keepSignedIn: keepSignedIn);
    emit(state);
  }

  Future<void> focusPasswordTextField() async {
    state = state.copyWith(isEmailCorrect: true);
    emit(state);
  }

  Future<void> onPasswordInputChanged(String text) async {
    state = state.copyWith(isPasswordPrefixActive: text.length > 4);
    emit(state);
  }

  Future<void> onEmailInputChanged(String text) async {
    final isEmailValid = checkEmail(text);

    state = state.copyWith(
        isEmailPrefixActive: isEmailValid && text.isNotEmpty,
        status: LoginPageStatus.intial);
    emit(state);
  }

  Future<void> signInUser(CredentialsModel credentials) async {
    state = state.copyWith(status: LoginPageStatus.passwordSubmitting);
    emit(state);

    try {
      final result = await authenticateUsecase(
          CredentialsParams(credentials: credentials));

      if (result is Left) {
        state = state.copyWith(status: LoginPageStatus.loginFailed);
      }

      final session = (result as Right).value;
      final sharedPrefs = await SharedPreferences.getInstance();
      final keepUserSignedIn = sharedPrefs.getBool('keepSignedIn');
      sharedPrefs.setString('authorizationToken', session.token);
      state = state.copyWith(status: LoginPageStatus.loginSuccesful);
    } catch (_) {
      state = state.copyWith(status: LoginPageStatus.loginFailed);
    }

    emit(state);
  }
}
