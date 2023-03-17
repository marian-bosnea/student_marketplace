import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/credentials_model.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/credentials/check_email_availability_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/faculty/get_all_faculties_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/sign_up_usecase.dart';

import '../../core/utils/input_validators.dart';
import 'register_view_state.dart';

class RegisterViewBloc extends Cubit<RegisterViewState> {
  final SignUpUsecase signUpUsecase;
  final GetAllFacultiesUsecase getAllFacultiesUsecase;
  final CheckEmailAvailabilityUsecase checkEmailRegistrationUsecase;

  late RegisterViewState state = const RegisterViewState();

  RegisterViewBloc(
      {required this.signUpUsecase,
      required this.getAllFacultiesUsecase,
      required this.checkEmailRegistrationUsecase})
      : super(const RegisterViewState());

  Future<void> fetchAllFaculties() async {
    final result = await getAllFacultiesUsecase(NoParams());
    final faculties = result.getOrElse(() => []);

    state = state.copyWith(faculties: faculties);
    emit(state);
  }

  Future<void> checkEmailForAvailability(CredentialsModel credentials) async {
    state = state.copyWith(emailValue: credentials.email);
    final isEmailValid = checkEmail(credentials.email);

    if (credentials.email.trim().isEmpty || !isEmailValid) {
      state = state.copyWith(showEmailCheckmark: false);
    } else {
      final result = await checkEmailRegistrationUsecase(
          CredentialsParams(credentials: credentials));

      if (result is Left) {
        state = state.copyWith(showEmailCheckmark: false);
      }
      final isEmailAlreadyRegistered = (result as Right).value;

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

  Future<void> setFirstName(String value) async {
    state = state.copyWith(firstNameValue: value);
  }

  Future<void> setLastName(String value) async {
    state = state.copyWith(lastNameValue: value);
  }

  Future<void> setSecondLastName(String value) async {
    state = state.copyWith(secondLastNameValue: value);
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

  checkPersonalInfo() {
    if (state.firstNameValue.isNotEmpty &&
        state.lastNameValue.isNotEmpty &&
        state.selectedFacultyId != '') {
      state = state.copyWith(status: RegisterPageStatus.validPersonalInfo);
    }
  }

  Future<void> onSelectImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final result = await image.readAsBytes();
      state = state.copyWith(hasUploadedPhoto: true, avatarImage: result);
      emit(state);
    }
  }

  Future<void> onSelectFaculty(String id) async {
    state = state.copyWith(selectedFacultyId: id);
    checkPersonalInfo();
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

  Future<void> registerUser() async {
    UserModel m = UserModel(
        email: state.emailValue,
        password: state.passwordValue,
        confirmPassword: state.confirmPasswordValue,
        firstName: state.firstNameValue,
        lastName: state.lastNameValue,
        secondaryLastName: state.secondLastNameValue,
        facultyName: state.selectedFacultyId,
        avatarImage: state.avatarImage);
    final result = await signUpUsecase(UserParam(user: m));

    final success = result.getOrElse(() => false);
    state = state.copyWith(
        status: success
            ? RegisterPageStatus.submissionSuccessful
            : RegisterPageStatus.submissionFailed);
    emit(state);
  }
}
