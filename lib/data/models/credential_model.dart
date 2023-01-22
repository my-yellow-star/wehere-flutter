class CredentialModel {
  final String accessToken;
  final String refreshToken;

  CredentialModel(this.accessToken, this.refreshToken);

  factory CredentialModel.fromJson(dynamic json) =>
      CredentialModel(json['accessToken'], json['refreshToken']);
}
