import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_marketplace_frontend/features/data/models/auth_session_model.dart';
import 'package:student_marketplace_frontend/features/domain/usecases/authentication/authenticate_usecase.dart';
import '../../../core/input_validators.dart';
import '../../domain/usecases/user/check_email_registration.dart';
import '../../../core/usecases/usecase.dart';
import '../../domain/usecases/user/sign_up_usecase.dart';
import 'login_page_state.dart';
import '../../data/models/user_model.dart';

class LoginCubit extends Cubit<LoginPageState> {
  final SignUpUsecase signUpUsecase;
  final AuthenticateUsecase authenticateUsecase;
  final CheckEmailRegistration checkEmailRegistrationUsecase;

  late bool keepSignedIn = false;
  late bool isEmailCorrect = false;

  late LoginPageState state = LoginPageState();

  LoginCubit(
      {required this.checkEmailRegistrationUsecase,
      required this.authenticateUsecase,
      required this.signUpUsecase})
      : super(const LoginPageState());

  Future<void> checkIfEmailIsRegistered(UserModel user) async {
    state = state.copyWith(status: LoginPageStatus.emailSubmitting);
    emit(state);

    try {
      final success =
          (await checkEmailRegistrationUsecase(UserParam(user: user)))
              .getOrElse(() => false);
      state = state.copyWith(
          status:
              success ? LoginPageStatus.emailSucces : LoginPageStatus.intial);
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

  Future<void> signInUser(UserModel user) async {
    state = state.copyWith(status: LoginPageStatus.passwordSubmitting);
    emit(state);

    try {
      final result = await authenticateUsecase(
          CredentialsParams(email: user.email!, password: user.password!));

      final session = result.getOrElse(() => const AuthSessionModel(token: ''));

      if (session.token == '') {
        state = state.copyWith(status: LoginPageStatus.loginFailed);
      } else {
        final sharedPrefs = await SharedPreferences.getInstance();
        final keepUserSignedIn = sharedPrefs.getBool('keepSignedIn');
        if (keepUserSignedIn != null && keepUserSignedIn) {
          sharedPrefs.setString('authorizationToken', session.token);
        }
        state = state.copyWith(status: LoginPageStatus.loginSuccesful);
      }
    } catch (_) {
      state = state.copyWith(status: LoginPageStatus.loginFailed);
    }

    emit(state);
  }
}
