import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_marketplace_frontend/core/enums.dart';
import 'package:student_marketplace_frontend/features/presentation/register/register_page.dart';

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
    if (email.trim().isEmpty) {
      emit(state.copyWith(showEmailCheckmark: false));
    } else {
      final result = await checkEmailRegistrationUsecase(
          UserParam(user: UserModel(email: email)));
      final isEmailAlreadyRegistered = result.getOrElse(() => false);
      emit(state.copyWith(showEmailCheckmark: !isEmailAlreadyRegistered));
    }
  }

  Future<void> checkIfPasswordIsValid(List<String> input) async {
    final password = input[1];
    emit(state.copyWith(showPasswordWarning: password.length <= 4));
  }

  Future<void> checkIfPasswordsMatch(List<String> input) async {
    if (input[2].length > 4) {
      final arePasswordsTheSame = input[1].compareTo(input[2]) == 0;
      emit(state.copyWith(showConfirmPasswordWarning: !arePasswordsTheSame));
    }
  }

  Future<void> registerUser(List<String> input) async {
    final result = await signUpUsecase(UserParam(
        user: UserModel(
            email: input[0],
            password: input[1],
            firstName: input[3],
            lastName: input[4],
            secondaryLastName: input[5],
            facultyName: input[6])));

    final success = result.getOrElse(() => false);
    if (success) {
      emit(state.copyWith(status: FormStatus.succesSubmission));
    } else {
      emit(state.copyWith(status: FormStatus.failedSubmission));
    }
  }
}
