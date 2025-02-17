part of 'privacy_cubit.dart';

@immutable
sealed class PrivacyState {}

final class PrivacyInitial extends PrivacyState {}
class PrivacyPolicyLoading extends PrivacyState {}
class PrivacyPolicyLoaded extends PrivacyState {
  final String policy;
  PrivacyPolicyLoaded(this.policy);
}
class PrivacyPolicyError extends PrivacyState {
  final String message;
  PrivacyPolicyError(this.message);
}
