import 'package:dodal_app/helper/validator.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../services/user_service.dart';
import '../main_route/main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.socialType,
    required this.socialId,
  });

  final SocialType socialType;
  final String socialId;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String _nickname = '';

  _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    SignUpResponse res = await UserService.signUp(
      widget.socialType,
      widget.socialId,
      'test@test.com',
      _nickname,
      '안녕하세요',
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
              TextFormField(
                decoration: const InputDecoration(labelText: '닉네임'),
                onSaved: (value) {
                  _nickname = value!;
                },
                validator: Validator.nickname,
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
