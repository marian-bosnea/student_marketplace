import 'package:equatable/equatable.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState extends Equatable {
  final String? token;
  final AuthStatus status;
  const AuthState({this.token, this.status = AuthStatus.initial});

  AuthState copyWith({String? token, AuthStatus? status}) =>
      AuthState(token: token ?? this.token, status: status ?? this.status);

  @override
  List<Object?> get props => [token, status];
}
