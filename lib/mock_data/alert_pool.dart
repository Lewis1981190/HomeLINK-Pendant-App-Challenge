import 'package:cloud_firestore/cloud_firestore.dart';

final List<Map<String, dynamic>> alertPool = [
  {
    'date': Timestamp.fromDate(DateTime.now()),
    'reason': 'SOS pendant activation',
    'addressLine1': '24 Lema Lane',
    'postcode': 'BS1 8MN',
    'senderName': 'John Corn',
  },
  {
    'date': Timestamp.fromDate(DateTime.now().subtract(Duration(minutes: 3))),
    'reason': 'Fall detected',
    'addressLine1': '12 Oak Street',
    'postcode': 'BS2 3XY',
    'senderName': 'Jane Smith',
  },
  {
    'date': Timestamp.fromDate(DateTime.now().subtract(Duration(minutes: 7))),
    'reason': 'Smoke alarm triggered',
    'addressLine1': '7 Maple Avenue',
    'postcode': 'BS3 4AB',
    'senderName': 'Alex Brown',
  },
];