import 'package:flutter/material.dart';
import 'package:homelink_pendant_app/generic_placeholder_widget.dart';

class GenericPlaceholderPage extends StatelessWidget {
  final String description;
  const GenericPlaceholderPage({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD1E2F7), Color(0xFFFFFFFF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: GenericPlaceholderWidget(description: description),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 50, left: 24, right: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 71, 160, 255),
                  ),
                  child: const Text('Back', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
