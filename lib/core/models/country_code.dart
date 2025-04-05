class CountryCode {
  final String name;
  final String dialCode;
  final String code;

  CountryCode({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      name: json['name'] as String,
      dialCode: json['dial_code'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dial_code': dialCode,
      'code': code,
    };
  }
}