part of 'chage_password_cubit.dart';

@immutable
sealed class ChagePasswordState {}

final class ChagePasswordInitial extends ChagePasswordState {}
final class ChagePasswordLoading extends ChagePasswordState {}
final class ChagePasswordSuccess extends ChagePasswordState {}
final class ChagePasswordFauiler extends ChagePasswordState {
  final String err;

  ChagePasswordFauiler({required this.err});
  
}
final class ChagePasswordwrongPasswrod extends ChagePasswordState {}
final class ChagePasswordConfirmPassword extends ChagePasswordState {}
