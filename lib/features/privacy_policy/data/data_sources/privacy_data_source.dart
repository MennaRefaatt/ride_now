import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PrivacyDataSource {
  Future<String> getPrivacyPolicy();
}

class PrivacyDataSourceImpl implements PrivacyDataSource {
  final FirebaseFirestore _firestore;

  PrivacyDataSourceImpl(this._firestore);

  @override
  Future<String> getPrivacyPolicy() async {
    final doc = await _firestore.collection('config').doc('privacy_policy').get();
    return doc.exists ? (doc.data()?['content'] ?? 'No privacy policy available.') : 'Privacy policy not found.';
  }
}