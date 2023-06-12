import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthService {
  static Future<AuthorizationCredentialAppleID?> signIn() async {
    try {
      return await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } catch (error) {
      print('애플 로그인 실패 $error');
      return null;
    }
  }
}
