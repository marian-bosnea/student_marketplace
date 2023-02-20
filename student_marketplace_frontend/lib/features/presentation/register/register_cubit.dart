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
      : super(InitialRegisterState());

  Future<void> checkEmailForAvailability(String email) async {
    final result = await checkEmailRegistrationUsecase(
        UserParam(user: UserModel(email: email)));

    final isEmailAlreadyRegistered = result.getOrElse(() => false);

    emit(isEmailAlreadyRegistered
        ? RegisterInvalidEmail()
        : RegisterValidEmail());
  }

  Future<void> registerUser(UserModel user) async {
    final result = await signUpUsecase(UserParam(user: user));
  }
}
