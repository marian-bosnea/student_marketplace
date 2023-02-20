// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:student_marketplace_frontend/core/enums.dart';

class RegisterPageState extends Equatable {
  final bool isEmailAvailable;
  final FormStatus status;

  const RegisterPageState({
    this.status = FormStatus.intial,
    this.isEmailAvailable = false,
  });

  @override
  List<Object?> get props => [status];
}
