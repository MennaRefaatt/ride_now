import 'package:ride_now/features/wallet/data/repositories/wallet_repo.dart';

class ChargeWalletUseCase {
  final WalletRepoBase repository;

  ChargeWalletUseCase(this.repository);

  Future<void> execute(String userId, double amount) {
    return repository.chargeWallet(userId, amount);
  }
}