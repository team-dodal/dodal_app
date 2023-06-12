import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static late GoogleSignIn instance;

  static void init() {
    instance = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      return await instance.signIn();
    } catch (error) {
      print('구글 로그인 실패 $error');
      return null;
    }
  }
}
