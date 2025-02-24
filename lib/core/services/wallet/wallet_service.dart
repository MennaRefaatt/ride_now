import 'package:cloud_firestore/cloud_firestore.dart';

class WalletService {
  final FirebaseFirestore _firestore;

  WalletService(this._firestore);

  Future<void> createWalletForUser(String userId) async {
    final walletRef = _firestore.collection('wallet').doc(userId);
    final walletData = await walletRef.get();

    if (!walletData.exists) {
      await walletRef.set({
        'balance': 0.0,
        'lastUpdated': DateTime.now(),
      });
    }
  }
}
