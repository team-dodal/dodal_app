import 'package:dodal_app/model/user_model.dart';

class SignUpResponse {
  String? accessToken, refreshToken;

  SignUpResponse.fromJson(Map<String, dynamic> data)
      : accessToken = data['access_token'],
        refreshToken = data['refresh_token'];
}

class SignInResponse extends User {
  final String? accessToken, refreshToken;
  final bool isSigned;

  SignInResponse.fromJson(Map<String, dynamic> data)
      : accessToken = data['access_token'],
        refreshToken = data['refresh_token'],
        isSigned = data['is_signed']!.toLowerCase() == 'true',
        super.formJson(data);
}
