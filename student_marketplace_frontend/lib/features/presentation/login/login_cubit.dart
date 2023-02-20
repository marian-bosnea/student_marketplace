import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/user/check_email_registration.dart';
import '../../../core/usecases/usecase.dart';
import '../../domain/usecases/user/sign_in_usecase.dart';
import '../../domain/usecases/user/sign_up_usecase.dart';
import 'login_page_state.dart';
import '../../data/models/user_model.dart';

class LoginCubit extends Cubit<LoginPageState> {
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;
  final CheckEmailRegistration checkEmailRegistrationUsecase;

  late bool keepSignedIn = false;

  LoginCubit(
      {required this.checkEmailRegistrationUsecase,
      required this.signInUsecase,
      required this.signUpUsecase})
      : super(LoginPageState());

  Future<void> signInUser(UserModel user) async {
    emit(LoginPageState().copyWith(status: LoginStatus.submittingLoading));

    try {
      final result =
          (await signInUsecase(UserParam(user: user))).getOrElse(() => '');

      if (result == '') {
        emit(LoginPageState().copyWith(status: LoginStatus.failedSubmission));
      } else {
        final sharedPrefs = await SharedPreferences.getInstance();
        final keepUserSignedIn = sharedPrefs.getBool('keepSignedIn');
        if (keepUserSignedIn != null && keepUserSignedIn) {
          sharedPrefs.setString('authorizationToken', result);
        }
        emit(LoginPageState().copyWith(status: LoginStatus.succesSubmission));
      }
    } catch (_) {
      emit(LoginPageState().copyWith(status: LoginStatus.failedSubmission));
    }
  }

  Future<void> checkIfEmailIsRegistered(UserModel user) async {
    try {
      final result =
          (await checkEmailRegistrationUsecase(UserParam(user: user)))
              .getOrElse(() => false);
      if (result) {
        emit(LoginPageState()
            .copyWith(status: LoginStatus.inProgress, isEmailCorrect: true));
      } else {
        emit(LoginPageState()
            .copyWith(status: LoginStatus.inProgress, isEmailCorrect: false));
      }
    } catch (_) {
      emit(LoginPageState()
          .copyWith(status: LoginStatus.inProgress, isEmailCorrect: false));
    }
  }

  Future<void> changeKeepSignedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    keepSignedIn = !keepSignedIn;

    sharedPrefs.setBool('keepSignedIn', keepSignedIn);
    emit(LoginPageState().copyWith(keepSignedIn: keepSignedIn));
  }

  Future<void> focusEmailTextField() async {
    emit(LoginPageState()
        .copyWith(isEmailFieldFocused: true, isPasswordFieldFocused: false));
  }

  Future<void> focusPasswordTextField() async {
    emit(LoginPageState()
        .copyWith(isEmailFieldFocused: false, isPasswordFieldFocused: true));
  }
}
