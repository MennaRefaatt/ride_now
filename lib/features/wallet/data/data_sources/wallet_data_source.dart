import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wallet_model.dart';

abstract class WalletDataSource {
  Future<void> chargeWallet(String userId, double amount);
  Future<Wallet> getWalletBalance(String userId);
}

class WalletDataSourceImpl implements WalletDataSource {
  final FirebaseFirestore _firestore;

  WalletDataSourceImpl(this._firestore);

  @override
  Future<void> chargeWallet(String userId, double amount) async {
    final walletRef = _firestore.collection('wallet').doc(userId);
    final walletData = await walletRef.get();
    double currentBalance = walletData.exists ? walletData['balance'] : 0.0;
    await walletRef.set({
      'balance': currentBalance + amount,
      'lastUpdated': DateTime.now(),
    });
  }

  @override
  Future<Wallet> getWalletBalance(String userId) async {
    final walletRef = _firestore.collection('wallet').doc(userId);
    final snapshot = await walletRef.get();

    if (!snapshot.exists) {
      final wallet = Wallet(userId: userId, balance: 0.0, lastUpdated: DateTime.now());
      await walletRef.set(wallet.toMap());
      return wallet;
    }

    return Wallet.fromFirestore(snapshot);
  }

}
