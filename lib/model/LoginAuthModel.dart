class LoginAuthModel {
  String accessToken = '';
  String tokenType = '';
  String refreshToken = '';
  int expiresIn = 0;
  String scope = '';
  String topic = '';
  String redirectTo = '';
  String jti = '';

  LoginAuthModel(
      {this.accessToken = '',
      this.tokenType = '',
      this.refreshToken = '',
      this.expiresIn = 0,
      this.scope = '',
      this.topic = '',
      this.redirectTo = '',
      this.jti = ''});

  LoginAuthModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    scope = json['scope'];
    topic = json['topic'];
    redirectTo = json['redirectTo'];
    jti = json['jti'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['refresh_token'] = this.refreshToken;
    data['expires_in'] = this.expiresIn;
    data['scope'] = this.scope;
    data['topic'] = this.topic;
    data['redirectTo'] = this.redirectTo;
    data['jti'] = this.jti;
    return data;
  }
}
