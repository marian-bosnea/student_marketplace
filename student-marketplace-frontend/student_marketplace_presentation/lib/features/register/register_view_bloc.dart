import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_marketplace_business_logic/core/usecase/usecase.dart';
import 'package:student_marketplace_business_logic/data/models/credentials_model.dart';
import 'package:student_marketplace_business_logic/data/models/user_model.dart';
import 'package:student_marketplace_business_logic/domain/usecases/credentials/check_email_availability_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/faculty/get_all_faculties_usecase.dart';
import 'package:student_marketplace_business_logic/domain/usecases/user/sign_up_usecase.dart';
import 'package:student_marketplace_presentation/core/config/on_generate_route.dart';

import '../../core/utils/input_validators.dart';
import 'register_view_state.dart';

class RegisterViewBloc extends Cubit<RegisterViewState> {
  final SignUpUsecase signUpUsecase;
  final GetAllFacultiesUsecase getAllFacultiesUsecase;
  final CheckEmailAvailabilityUsecase checkEmailRegistrationUsecase;

  RegisterViewBloc(
      {required this.signUpUsecase,
      required this.getAllFacultiesUsecase,
      required this.checkEmailRegistrationUsecase})
      : super(const RegisterViewState());

  Future<void> fetchAllFaculties() async {
    final result = await getAllFacultiesUsecase(NoParams());
    final faculties = result.getOrElse(() => []);

    emit(state.copyWith(faculties: faculties));
  }

  Future<void> onSelectFaculty(String id) async {
    emit(state.copyWith(selectedFacultyId: id));
  }

  Future<void> checkEmailForAvailability(CredentialsModel credentials) async {
    emit(state.copyWith(emailValue: credentials.email));
    final isEmailValid = checkEmail(credentials.email);

    if (credentials.email.trim().isEmpty || !isEmailValid) {
      emit(state.copyWith(showEmailCheckmark: false));
    } else {
      final result = await checkEmailRegistrationUsecase(
          CredentialsParams(credentials: credentials));

      if (result is Left) {
        emit(state.copyWith(showEmailCheckmark: false));
      }
      final isEmailAlreadyRegistered = (result as Right).value;

      emit(state.copyWith(showEmailCheckmark: !isEmailAlreadyRegistered));
    }
    emit(state);
    _checkCredentialsFormValidity();
  }

  Future<void> checkIfPasswordIsValid(String value) async {
    emit(state.copyWith(passwordValue: value));

    if (value.trim().isEmpty) {
      emit(state.copyWith(showPasswordWarning: false));
      return;
    }

    final isPasswordValid = checkPassword(value);
    emit(state.copyWith(
        passwordValue: value, showPasswordWarning: !isPasswordValid));

    checkIfPasswordsMatch(state.confirmPasswordValue);
  }

  Future<void> checkIfPasswordsMatch(String value) async {
    if (value.trim().isEmpty) {
      emit(state.copyWith(showConfirmPasswordWarning: false));
      return;
    }

    final arePasswordsTheSame = state.passwordValue.compareTo(value) == 0;
    emit(state.copyWith(
        confirmPasswordValue: value,
        showConfirmPasswordWarning: !arePasswordsTheSame));
  }

  Future<void> setFirstName(String value) async {
    emit(state.copyWith(firstNameValue: value));
  }

  Future<void> setLastName(String value) async {
    emit(state.copyWith(lastNameValue: value));
  }

  Future<void> setSecondLastName(String value) async {
    emit(state.copyWith(secondLastNameValue: value));
  }

  Future<void> goToNextStep(BuildContext context) async {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    } else {
      registerUser(context);
    }
  }

  Future<void> goToPreviousStep() async {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  bool _checkPersonalInfoFormValidity() =>
      state.firstNameValue.isNotEmpty &&
      state.lastNameValue.isNotEmpty &&
      state.selectedFacultyId != '';

  Future<void> onSelectImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final result = await image.readAsBytes();
      emit(state.copyWith(hasUploadedPhoto: true, avatarImage: result));
    }
  }

  _checkCredentialsFormValidity() =>
      state.showEmailCheckmark &&
      checkPassword(state.passwordValue) &&
      state.passwordValue == state.confirmPasswordValue;

  Future<void> registerUser(BuildContext context) async {
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
    emit(state.copyWith(
        status: success
            ? RegisterPageStatus.submissionSuccessful
            : RegisterPageStatus.submissionFailed));
    if (state.status == RegisterPageStatus.submissionSuccessful) {
      emit(state.copyWith(currentStep: 0));
      Navigator.of(context).pushReplacementNamed(PageNames.authenticationPage);
    }
  }

  bool canGoToNextStep() {
    if (state.currentStep == 0) return _checkCredentialsFormValidity();
    if (state.currentStep == 1) return _checkPersonalInfoFormValidity();
    if (state.currentStep == 2) return state.hasUploadedPhoto;

    return false;
  }
}
