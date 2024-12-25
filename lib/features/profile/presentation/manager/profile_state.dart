part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  ProfileLoaded(this.profile);
}
class ProfileSaved extends ProfileState {}
class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
