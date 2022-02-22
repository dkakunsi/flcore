import 'package:api/domain/entity/token_entity.dart';

abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}

class AuthenticatingState extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {
  final TokenEntity token;

  AuthenticatedState(this.token);
}

class LoggedOutState extends AuthenticationState {}

class FailedAuthenticationState extends AuthenticationState {
  final dynamic error;

  FailedAuthenticationState(this.error);
}
