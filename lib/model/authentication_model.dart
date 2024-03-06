import 'package:dodal_app/model/user_model.dart';
import 'package:equatable/equatable.dart';

class Authentication extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final User user;

  const Authentication({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory Authentication.fromJson(Map<String, dynamic> data) {
    return Authentication(
      accessToken: data['access_token'],
      refreshToken: data['refresh_token'],
      user: User.fromJson(data),
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
