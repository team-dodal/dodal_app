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

  static Future<void> signIn() async {
    try {
      final res = await instance.signIn();
      print(res);
    } catch (error) {
      print(error);
    }
  }
}
