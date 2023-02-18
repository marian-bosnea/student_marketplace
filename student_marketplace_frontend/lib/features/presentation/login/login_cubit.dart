import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/usecases/usecase.dart';
import '../../domain/usecases/user/sign_in_usecase.dart';
import '../../domain/usecases/user/sign_up_usecase.dart';
import 'login_form_submission_status.dart';

import '../../data/models/user_model.dart';
import 'login_state.dart';

import '../../../core/injection_container.dart' as di;

class LoginCubit extends Cubit<LoginState> {
  final SignInUsecase signInUsecase;
  final SignUpUsecase signUpUsecase;

  LoginCubit({required this.signInUsecase, required this.signUpUsecase})
      : super(LoginState());

  onEmailChanged(String value) =>
      emit(state.copyWith(email: value, status: const InitalFormStatus()));

  onPasswordChanged(String value) {
    emit(state.copyWith(password: value, status: const InitalFormStatus()));
  }

  onSubmitForm() async {
    if (!state.isValid) return;
    final result = await di.sl<SignInUsecase>().call(UserParam(
        user: UserModel(email: state.email, password: state.password)));

    if (result.isRight() && result.getOrElse(() => '') != '') {
      emit(state.copyWith(status: SubmissionSuccess()));
    } else {
      emit(state.copyWith(status: SubmissionFailed(exception: Exception())));
    }
  }

  Future<void> signInUser(UserModel user) async {
    emit(state.copyWith(status: FormSubmitting()));

    final sharedPrefs = await SharedPreferences.getInstance();
    try {
      final result =
          (await signInUsecase(UserParam(user: user))).getOrElse(() => '');

      if (result == '') {
        emit(state.copyWith(status: SubmissionFailed(exception: Exception())));
      } else {
        sharedPrefs.setString('authorizationToken', result);
        emit(state.copyWith(status: SubmissionSuccess()));
      }
    } catch (_) {
      emit(state.copyWith(status: SubmissionFailed(exception: Exception())));
    }
  }
}
