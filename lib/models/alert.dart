import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  final String id;
  final Timestamp date;
  final String reason;
  final String addressLine1;
  final String postcode;
  final String senderName;

  Alert({
    required this.id,
    required this.date,
    required this.reason,
    required this.addressLine1,
    required this.postcode,
    required this.senderName,
  });

  factory Alert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Alert(
      id: doc.id,
      date: data['date'] ?? '',
      reason: data['reason'] ?? '',
      addressLine1: data['address_line_1'] ?? '',
      postcode: data['postcode'] ?? '',
      senderName: data['sender_name'] ?? '',
    );
  }
}