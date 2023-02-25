import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/core/input_validators.dart';
import '../../../core/usecases/usecase.dart';
import '../../domain/usecases/faculty/get_all_faculties_usecase.dart';
import '../../domain/usecases/user/check_email_registration.dart';
import '../../domain/usecases/user/sign_up_usecase.dart';
import 'register_page_state.dart';
import '../../data/models/user_model.dart';

class RegisterCubit extends Cubit<RegisterPageState> {
  final SignUpUsecase signUpUsecase;
  final GetAllFaculties getAllFacultiesUsecase;
  final CheckEmailRegistration checkEmailRegistrationUsecase;

  late RegisterPageState state = RegisterPageState();

  RegisterCubit(
      {required this.signUpUsecase,
      required this.getAllFacultiesUsecase,
      required this.checkEmailRegistrationUsecase})
      : super(const RegisterPageState());

  Future<void> checkEmailForAvailability(String email) async {
    state.copyWith(emailValue: email);
    final isEmailValid = checkEmail(email);

    if (email.trim().isEmpty || !isEmailValid) {
      state = state.copyWith(showEmailCheckmark: false);
    } else {
      final result = await checkEmailRegistrationUsecase(
          UserParam(user: UserModel(email: email)));
      final isEmailAlreadyRegistered = result.getOrElse(() => false);
      state = state.copyWith(showEmailCheckmark: !isEmailAlreadyRegistered);
    }
    emit(state);
    _checkIfCredentialsFormIsValid();
  }

  Future<void> checkIfPasswordIsValid(String value) async {
    state = state.copyWith(passwordValue: value);

    if (value.trim().isEmpty) {
      state = state.copyWith(showPasswordWarning: false);
      emit(state);
      return;
    }

    final isPasswordValid = checkPassword(value);
    state = state.copyWith(
        passwordValue: value, showPasswordWarning: !isPasswordValid);
    emit(state);

    checkIfPasswordsMatch(state.confirmPasswordValue);
  }

  Future<void> checkIfPasswordsMatch(String value) async {
    if (value.trim().isEmpty) {
      state = state.copyWith(showConfirmPasswordWarning: false);
      emit(state);
      return;
    }

    final arePasswordsTheSame = state.passwordValue.compareTo(value) == 0;
    state = state.copyWith(
        confirmPasswordValue: value,
        showConfirmPasswordWarning: !arePasswordsTheSame);
    emit(state);
  }

  Future<void> goToNextStep() async {
    if (state.status == RegisterPageStatus.validCredentials) {
      state = state.copyWith(status: RegisterPageStatus.personalInfoInProgress);
      emit(state);
    }
    if (state.status == RegisterPageStatus.personalInfoInProgress) {
      //state = state.copyWith(status: RegisterPageStatus.credentialsInProgress);
      //emit(state);
    }
    if (state.status == RegisterPageStatus.validPersonalInfo) {
      //_registerUser
    }
  }

  Future<void> goToPreviousStep() async {
    state = state.copyWith(status: RegisterPageStatus.validCredentials);
    emit(state);
  }

  _checkIfCredentialsFormIsValid() {
    if (state.showEmailCheckmark &&
        !state.showPasswordWarning &&
        !state.showConfirmPasswordWarning) {
      state = state.copyWith(status: RegisterPageStatus.validCredentials);
      emit(state);
    }
  }

  Future<void> _registerUser(List<String> input) async {
    final result = await signUpUsecase(UserParam(
        user: UserModel(
            email: input[0],
            password: input[1],
            firstName: input[3],
            lastName: input[4],
            secondaryLastName: input[5],
            facultyName: input[6])));

    final success = result.getOrElse(() => false);
    state = state.copyWith(
        status: success
            ? RegisterPageStatus.submissionSuccessful
            : RegisterPageStatus.submissionFailed);
    emit(state);
  }
}
