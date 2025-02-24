import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'wallet_model.g.dart';
@JsonSerializable()
class Wallet {
  final String userId;
  final double balance;
  final DateTime lastUpdated;

  Wallet({
    required this.userId,
    required this.balance,
    required this.lastUpdated,
  });

  factory Wallet.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Wallet(
      userId: doc.id,
      balance: data?['balance']?.toDouble() ?? 0.0,
      lastUpdated: data?['lastUpdated'] ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'balance': balance,
      'lastUpdated': lastUpdated,
    };
  }
}
