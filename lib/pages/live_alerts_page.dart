import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homelink_pendant_app/widgets/live_alert_card.dart';
import 'package:homelink_pendant_app/models/alert.dart';
import 'package:homelink_pendant_app/mock_data/alert_pool.dart';
import 'dart:math';

class LiveAlertsPage extends StatefulWidget {
  const LiveAlertsPage({super.key});

  @override
  State<LiveAlertsPage> createState() => _LiveAlertsPageState();
}

class _LiveAlertsPageState extends State<LiveAlertsPage> {
  void _removeCard(String id) async {
    await FirebaseFirestore.instance.collection('liveAlerts').doc(id).delete();
  }

  Future<void> _addRandomAlert() async {
    final rawAlert = alertPool[Random().nextInt(alertPool.length)];
    // Map to Firestore field names
  final alertData = {
    'date': rawAlert['date'],
    'reason': rawAlert['reason'],
    'address_line_1': rawAlert['addressLine1'],
    'postcode': rawAlert['postcode'],
    'sender_name': rawAlert['senderName'],
  };
    await FirebaseFirestore.instance.collection('liveAlerts').add(alertData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('liveAlerts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Waiting for alerts...'));
              }
              final alerts = snapshot.data!.docs
                  .map(Alert.fromFirestore)
                  .toList();
              return SingleChildScrollView(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...alerts.map(
                        (alert) => LiveAlertCard(
                          key: ValueKey(alert.id),
                          alert: alert,
                          onResolved: () => _removeCard(alert.id),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: ElevatedButton(
            onPressed: _addRandomAlert,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 71, 160, 255),
            ),
            child: const Text(
              'DEBUG: Add Alert',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
