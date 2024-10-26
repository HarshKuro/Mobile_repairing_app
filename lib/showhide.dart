// showhide.dart
import 'package:flutter/material.dart';

class ShowHideCustomers extends StatelessWidget {
  final bool showCustomers;
  final VoidCallback onToggle;

  const ShowHideCustomers({
    super.key,
    required this.showCustomers,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onToggle,
          child: Text(
            showCustomers ? "Hide all" : "Show all",
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}