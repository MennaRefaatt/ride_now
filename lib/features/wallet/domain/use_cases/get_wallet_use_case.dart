import 'package:ride_now/features/wallet/data/models/wallet_model.dart';
import 'package:ride_now/features/wallet/data/repositories/wallet_repo.dart';

class GetWalletBalanceUseCase {
  final WalletRepoBase repository;

  GetWalletBalanceUseCase(this.repository);

  Future<Wallet> execute(String userId) {
    return repository.getWalletBalance(userId);
  }
}