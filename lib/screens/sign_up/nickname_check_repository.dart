import 'package:dodal_app/services/user/service.dart';

class NicknameCheckRepository {
  Future<bool> checkNickname(String nickname) async {
    final res = await UserService.checkNickName(nickname);
    return res;
  }
}
