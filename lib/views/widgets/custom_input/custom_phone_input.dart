import 'package:flutter/material.dart';
import 'package:MELODY/core/models/country_code.dart';
import 'package:MELODY/views/widgets/custom_input/country_code_dropdown.dart';

class CustomPhoneInput extends StatelessWidget {
  final TextEditingController phoneController;
  final List<CountryCode> countryCodes;
  final CountryCode selectedCountry;
  final Function(CountryCode) onCountryChanged;
  final Function(String)? onChanged;
  final String? phoneError;
  final bool? hasBorder;

  const CustomPhoneInput({
    super.key,
    required this.phoneController,
    required this.countryCodes,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.onChanged,
    this.phoneError,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border:
                hasBorder == true
                    ? Border.all(color: Colors.black12)
                    : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 3,
                offset: Offset(-1.8, 1.8),
              ),
            ],
          ),
          child: Row(
            children: [
              CountryCodeDropdown(
                countryCodes: countryCodes,
                selectedCountry: selectedCountry,
                onChanged: (country) {
                  onCountryChanged(country);
                },
              ),
              Container(
                height: 53,
                width: 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
              ),
              Expanded(
                child: PhoneInputField(
                  controller: phoneController,
                  hintText: 'Số điện thoại',
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
        if (phoneError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: Text(
              phoneError!,
              style: TextStyle(
                color: Colors.red.shade300,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            borderSide: BorderSide.none,
          ),
          prefixIcon:
              prefixIcon != null
                  ? Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: prefixIcon, // myIcon is a 48px-wide widget.
                  )
                  : null,
          suffixIcon:
              suffixIcon != null
                  ? Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: suffixIcon, // myIcon is a 48px-wide widget.
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            borderSide: BorderSide.none,
          ),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
