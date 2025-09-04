import 'package:flutter/material.dart';

class GenericPlaceholderWidget extends StatelessWidget {
  final String description;

  const GenericPlaceholderWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.build, size: 64),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
            ),
            const SizedBox(height: 8),
            Text(
              'This screen is not yet implemented.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
          ],
        ),
      ),
    );
  }
}
