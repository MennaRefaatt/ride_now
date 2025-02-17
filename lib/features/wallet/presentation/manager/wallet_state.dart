part of 'wallet_cubit.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}

final class WalletCharged extends WalletState {}

final class WalletChargedError extends WalletState {
  final String message;

  WalletChargedError(this.message);
}

final class WalletLoading extends WalletState {}

final class WalletLoaded extends WalletState {
  final double balance;
  final bool isLoading;

  WalletLoaded({required this.balance, required this.isLoading});
}

final class WalletBalanceLoaded extends WalletState {
  final Wallet wallet;

  WalletBalanceLoaded({required this.wallet});
}

final class WalletBalanceError extends WalletState {
  final String message;

  WalletBalanceError(this.message);
}

final class WalletBalanceLoading extends WalletState {}
