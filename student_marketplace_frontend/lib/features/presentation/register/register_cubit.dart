import 'package:flutter_bloc/flutter_bloc.dart';

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

  RegisterCubit(
      {required this.signUpUsecase,
      required this.getAllFacultiesUsecase,
      required this.checkEmailRegistrationUsecase})
      : super(const RegisterPageState());

  Future<void> checkEmailForAvailability(String email) async {
    if (email.isEmpty) {
      emit(const RegisterPageState(isEmailAvailable: false));
      print("not available!");
    } else {
      final result = await checkEmailRegistrationUsecase(
          UserParam(user: UserModel(email: email)));

      final isEmailAlreadyRegistered = result.getOrElse(() => false);

      print(!isEmailAlreadyRegistered ? "not available!" : "available!");

      emit(RegisterPageState(isEmailAvailable: !isEmailAlreadyRegistered));
    }
  }

  Future<void> registerUser(List<String> input) async {
    // final result = await signUpUsecase(UserParam(user: user));
  }
}
