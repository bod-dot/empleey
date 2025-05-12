part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeSuccess extends HomeState {}
final class HomeSuccessPutNoCollection extends HomeState {}
final class HomeFauler extends HomeState {
 
 final String err;

  HomeFauler({required this.err});
 

}
final class HomeNotAllow extends HomeState {}
final class HomeNoInternet extends HomeState {}
