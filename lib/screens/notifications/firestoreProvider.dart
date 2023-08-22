import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/notificationModel.dart';

class FirestoreProvider extends ChangeNotifier {
  final CollectionReference _notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<List<FirestoreNotification>> getNotifications() async {
    final querySnapshot = await _notificationsCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return FirestoreNotification(
        title: data['title'],
        message: data['message'],
        timestamp: DateTime.parse(data['timestamp']),
      );
    }).toList();
  }

  Future<void> addNotification(FirestoreNotification notification) async {
    await _notificationsCollection.add(notification.toMap());
    notifyListeners();
  }
}
