import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoBackButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.pop(context),
      child: Hero(
        tag: 'goBackButton',
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.arrow_back, size: 20),
        ),
      ),
    );
  }
}
