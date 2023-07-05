import 'package:dodal_app/helper/validator.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../services/user_service.dart';
import '../main_route/main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.socialType,
    required this.socialId,
    required this.email,
  });

  final SocialType socialType;
  final String socialId;
  final String email;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _nicknameChecked = false;
  String _nickname = '';
  String _content = '';

  _checkingNickname() async {
    final res = await UserService.checkNickName(_nickname);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => SystemDialog(
        title: res ? '사용할 수 있는 닉네임입니다.' : '사용할 수 없는 닉네임입니다.',
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
    setState(() {
      _nicknameChecked = res;
    });
  }

  _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    SignUpResponse res = await UserService.signUp(
      widget.socialType,
      widget.socialId,
      widget.email,
      _nickname,
      '',
      _content,
      ["001001", "002003", "004001"],
    );

    if (res.accessToken != null && res.refreshToken != null) {
      secureStorage.write(key: 'accessToken', value: res.accessToken);
      secureStorage.write(key: 'refreshToken', value: res.refreshToken);

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const MainRoute()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원 가입')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: '닉네임'),
                        onChanged: (value) {
                          _nickname = value;
                        },
                        validator: (value) =>
                            Validator.signUpNickname(value, _nicknameChecked),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _checkingNickname,
                      child: Text(_nicknameChecked ? '확인 완료' : '중복 확인'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(labelText: '한 줄 소개'),
                onSaved: (value) {
                  _content = value!;
                },
                validator: Validator.signUpContent,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        width: double.infinity,
        child: FloatingActionButton(
          onPressed: _submit,
          child: const Text('회원가입'),
        ),
      ),
    );
  }
}
