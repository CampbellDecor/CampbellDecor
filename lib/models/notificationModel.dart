class FirestoreNotification {
  final String title;
  final String message;
  final DateTime timestamp;

  FirestoreNotification({
    required this.title,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
