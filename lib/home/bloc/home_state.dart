part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeSelectPictureState extends HomeState {
  late final File imageFile;

  HomeSelectPictureState(this.imageFile);
}
