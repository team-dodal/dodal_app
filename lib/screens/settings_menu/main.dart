import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMenuScreen extends StatefulWidget {
  const SettingsMenuScreen({super.key});

  @override
  State<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends State<SettingsMenuScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late SharedPreferences pref;
  bool _notification = true;

  _signOut() async {
    secureStorage.deleteAll();
    if (!mounted) return;
    context.read<UserCubit>().clear();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const SignInScreen()),
        (route) => false);
  }

  _removeMyAccount() async {
    await UserService.removeUser();
    await secureStorage.deleteAll();
    if (!mounted) return;
    context.read<UserCubit>().clear();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const SignInScreen()),
        (route) => false);
  }

  _getNotificationValue() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      _notification = pref.getBool('notification_allow')!;
    });
  }

  _handleNotification(value) async {
    pref = await SharedPreferences.getInstance();
    pref.setBool('notification_allow', value);
    setState(() {
      _notification = value;
    });
  }

  @override
  void initState() {
    _getNotificationValue();
    super.initState();
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
            value: _notification,
            onChanged: _handleNotification,
          ),
          ListTile(
            title: const Text('로그아웃'),
            onTap: _signOut,
          ),
          ListTile(
            title: const Text(
              '회원 탈퇴',
              style: TextStyle(color: AppColors.danger),
            ),
            onTap: _removeMyAccount,
          ),
        ],
      ),
    );
  }
}
