part of 'auth_bloc.dart';

//
// EVENTS
//
abstract class AuthEvent {}
class SignIn  extends AuthEvent {
  String? email, password;

  SignIn(this.email, this.password);

}
class SignOut extends AuthEvent {}
