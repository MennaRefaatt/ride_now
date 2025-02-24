import '../data_sources/wallet_data_source.dart';
import '../models/wallet_model.dart';

abstract class WalletRepoBase {
  Future<void> chargeWallet(String userId, double amount);
  Future<Wallet> getWalletBalance(String userId);
}

class WalletRepo implements WalletRepoBase {
  final WalletDataSource walletDataSource;

  WalletRepo(this.walletDataSource);

  @override
  Future<void> chargeWallet(String userId, double amount) async {
    await walletDataSource.chargeWallet(userId, amount);
  }

  @override
  Future<Wallet> getWalletBalance(String userId) async {
    return await walletDataSource.getWalletBalance(userId);
  }
}
