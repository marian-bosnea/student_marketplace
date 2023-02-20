import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/enums.dart';
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
      : super(const LoginPageState());

  Future<void> signInUser(UserModel user) async {
    emit(const LoginPageState().copyWith(status: FormStatus.submittingLoading));

    try {
      final result =
          (await signInUsecase(UserParam(user: user))).getOrElse(() => '');

      if (result == '') {
        emit(const LoginPageState()
            .copyWith(status: FormStatus.failedSubmission));
      } else {
        final sharedPrefs = await SharedPreferences.getInstance();
        final keepUserSignedIn = sharedPrefs.getBool('keepSignedIn');
        if (keepUserSignedIn != null && keepUserSignedIn) {
          sharedPrefs.setString('authorizationToken', result);
        }
        emit(const LoginPageState()
            .copyWith(status: FormStatus.succesSubmission));
      }
    } catch (_) {
      emit(
          const LoginPageState().copyWith(status: FormStatus.failedSubmission));
    }
  }

  Future<void> checkIfEmailIsRegistered(UserModel user) async {
    try {
      final result =
          (await checkEmailRegistrationUsecase(UserParam(user: user)))
              .getOrElse(() => false);
      if (result) {
        emit(const LoginPageState()
            .copyWith(status: FormStatus.inProgress, isEmailCorrect: true));
      } else {
        emit(const LoginPageState()
            .copyWith(status: FormStatus.inProgress, isEmailCorrect: false));
      }
    } catch (_) {
      emit(const LoginPageState()
          .copyWith(status: FormStatus.inProgress, isEmailCorrect: false));
    }
  }

  Future<void> changeKeepSignedIn() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    keepSignedIn = !keepSignedIn;

    sharedPrefs.setBool('keepSignedIn', keepSignedIn);
    emit(const LoginPageState().copyWith(keepSignedIn: keepSignedIn));
  }

  Future<void> focusEmailTextField() async {
    emit(const LoginPageState()
        .copyWith(isEmailFieldFocused: true, isPasswordFieldFocused: false));
  }

  Future<void> focusPasswordTextField() async {
    emit(const LoginPageState()
        .copyWith(isEmailFieldFocused: false, isPasswordFieldFocused: true));
  }
}
