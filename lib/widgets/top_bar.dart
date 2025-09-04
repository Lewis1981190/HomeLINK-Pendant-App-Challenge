import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homelink_pendant_app/pages/generic_placeholder_page.dart';
import 'package:homelink_pendant_app/models/user.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  void _directToPlaceholderPage(String description) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => GenericPlaceholderPage(description: description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/plus_button.png', scale: 9),
                        onPressed: () {
                          _directToPlaceholderPage(
                            'Add and Comission New Device',
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Image.asset('assets/logo.png', scale: 9),
                            onPressed: () {
                              _directToPlaceholderPage(
                                'HomeLINK About / Info Page',
                              );
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* Use a FireStore stream to get real-time updates 
                            ** 
                            ** This is currently using a *real* user ID, but I've hardcoded it until I properly
                            ** implement authentication and login. 
                            */
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('userInfo')
                                  .doc('auX0RxMUM1bdBaTjoN8guCFAHd93')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text(
                                    'Loading...',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }

                                final user = User.fromFirestore(snapshot.data!);

                                return Text(
                                  'Hello, ${user.firstName} ${user.lastName}!',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                Text(
                                  'see your alerts below',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset('assets/person_icon.png', scale: 25),
                        onPressed: () {
                          _directToPlaceholderPage('Profile Settings Page');
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/settings.png', scale: 25),
                        onPressed: () {
                          _directToPlaceholderPage('App Settings Page');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
