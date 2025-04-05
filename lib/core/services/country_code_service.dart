import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:MELODY/core/models/country_code.dart';

class CountryCodeService {
  static List<CountryCode> _countryCodes = [];

  /// Loads country codes from the JSON file
  static Future<List<CountryCode>> loadCountryCodes() async {
    if (_countryCodes.isNotEmpty) {
      return _countryCodes;
    }

    try {
      final String response = await rootBundle.loadString(
        'lib/core/constants/country_codes.json',
      );
      final List<dynamic> data = json.decode(response) as List<dynamic>;

      _countryCodes =
          data
              .map((json) => CountryCode.fromJson(json as Map<String, dynamic>))
              .toList();

      return _countryCodes;
    } catch (e) {
      // Fallback to a default list with Vietnam if loading fails
      return [CountryCode(name: 'Vietnam', dialCode: '+84', code: 'VN')];
    }
  }

  /// Gets a country code by its dial code
  static CountryCode? getCountryByDialCode(String dialCode) {
    try {
      return _countryCodes.firstWhere(
        (country) => country.dialCode == dialCode,
      );
    } catch (e) {
      return null;
    }
  }

  /// Gets a country code by its country code
  static CountryCode? getCountryByCode(String code) {
    try {
      return _countryCodes.firstWhere((country) => country.code == code);
    } catch (e) {
      return null;
    }
  }
}
