import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsMenuScreen extends StatefulWidget {
  const SettingsMenuScreen({super.key});

  @override
  State<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends State<SettingsMenuScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  _signOut() async {
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'refreshToken');

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const SignInScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('알림'),
            value: Fcm.isAllow,
            onChanged: (value) {
              setState(() {
                value ? Fcm.requestPermission() : Fcm.isAllow = false;
              });
            },
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: _signOut,
          )
        ],
      ),
    );
  }
}
