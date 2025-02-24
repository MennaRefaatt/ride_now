import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/helpers/shared_pref.dart';
import '../../../../core/helpers/shared_pref_keys.dart';
import '../models/notification_model.dart';

abstract class NotificationDs {
  Stream<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationDsImpl implements NotificationDs {
  final FirebaseFirestore _firestore;

  NotificationDsImpl(this._firestore,);

  final userId = SharedPref.getString(key: MySharedKeys.userId);

  @override
  Stream<List<NotificationModel>> getNotifications() {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Future<void> markAsRead(String id) async {
    await _firestore.collection('notifications').doc(id).update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead() async {
    final batch = _firestore.batch();
    final querySnapshot = await _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId) // Mark only receiver's notifications
        .get();

    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }
}
