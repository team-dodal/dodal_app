class Validator {
  static String? signUpNickname(String? value, bool checked) {
    if (value!.isEmpty || value == '') {
      return '닉네임을 입력해 주세요!';
    } else if (value.length > 16) {
      return '닉네임은 16글자 이내로 해주세요.';
    } else if (!checked) {
      return '닉네임 중복 확인을 해주세요.';
    }
    return null;
  }

  static String? signUpContent(String? value) {
    if (value!.length > 50) {
      return '한줄 소개는 50글자 이내로 해주세요.';
    }
    return null;
  }
}
