class Authen {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;
  final bool? isNewUser;

  Authen({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.isNewUser,
  });

  factory Authen.fromJson(Map<String, dynamic> json) {
    return Authen(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      isNewUser: json['is_new_user'],
    );
  }
}
