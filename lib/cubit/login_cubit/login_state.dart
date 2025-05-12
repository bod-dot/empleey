part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoding extends LoginState {}
final class LoginSuccess extends LoginState {}
final class LoginWrongPasswrodOrPhone extends LoginState {}
final class LoginNoPermissoion extends LoginState {}
final class LoginNoInternet extends LoginState {}
final class LoginNotActive extends LoginState {}
final class LoginAreasLoading extends LoginState {}
final class LoginAreasLoaded extends LoginState {}
final class LoginFauild extends LoginState {
  final String error;
  LoginFauild( { required this.error});
}
