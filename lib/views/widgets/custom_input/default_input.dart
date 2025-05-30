import 'package:flutter/material.dart';

enum ShadowPositionType { left, right }

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ShadowPositionType? shadowPosition;
  final Function(String)? onChanged;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.shadowPosition = ShadowPositionType.right,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 3,
            offset:
                shadowPosition == ShadowPositionType.right
                    ? Offset(1.8, 0.2)
                    : Offset(-1.8, 1.8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIcon: prefixIcon != null ? Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: prefixIcon, // myIcon is a 48px-wide widget.
          ) : null,
          suffixIcon: suffixIcon != null ? Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: suffixIcon, // myIcon is a 48px-wide widget.
          ) : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
