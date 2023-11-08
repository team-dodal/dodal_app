import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
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
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
        subTitle: '로그아웃 하시겠습니까?',
        children: [
          SystemDialogButton(
            text: '취소',
            primary: false,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SystemDialogButton(
            text: '로그아웃',
            color: AppColors.danger,
            onPressed: () {
              secureStorage.deleteAll();
              if (!mounted) return;
              context.read<UserCubit>().clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const SignInScreen()),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }

  _removeMyAccount() async {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
        subTitle: '회원 탈퇴하시겠습니까?',
        children: [
          SystemDialogButton(
            text: '취소',
            primary: false,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SystemDialogButton(
            text: '확인',
            onPressed: () async {
              await UserService.removeUser();
              await secureStorage.deleteAll();
              if (!mounted) return;
              context.read<UserCubit>().clear();

              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const SignInScreen()),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    () async {
      _notification = await getNotificationValue();
      setState(() {});
    }();
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
            onChanged: (value) async {
              _notification = await setNotificationValue(value);
              setState(() {});
            },
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
