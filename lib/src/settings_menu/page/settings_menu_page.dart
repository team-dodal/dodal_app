import 'package:dodal_app/src/sign_in/bloc/sign_in_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/settings_menu/page/personal_data_rule_page.dart';
import 'package:dodal_app/src/settings_menu/page/service_rule_page.dart';
import 'package:dodal_app/src/sign_in/page/sign_in_page.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsMenuPage extends StatefulWidget {
  const SettingsMenuPage({super.key});

  @override
  State<SettingsMenuPage> createState() => _SettingsMenuPageState();
}

class _SettingsMenuPageState extends State<SettingsMenuPage> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
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
            onPressed: () {
              secureStorage.deleteAll();
              if (!mounted) return;
              context.read<UserBloc>().add(ClearUserBlocEvent());
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (ctx) => BlocProvider(
                      create: (context) =>
                          SignInBloc(const FlutterSecureStorage()),
                      child: const SignInPage(),
                    ),
                  ),
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
            color: AppColors.danger,
            onPressed: () {
              context.read<UserBloc>().add(RemoveUserBlocEvent());
              if (!mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (ctx) => BlocProvider(
                      create: (context) =>
                          SignInBloc(const FlutterSecureStorage()),
                      child: const SignInPage(),
                    ),
                  ),
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
      // _notification = await getNotificationValue();
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
            title: const Text('전체 알림 설정'),
            value: _notification,
            onChanged: (value) async {
              // _notification = await setNotificationValue(value);
              setState(() {
                _notification = value;
              });
            },
          ),
          ListTile(
            title: const Text('이용 약관'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceRulePage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('개인정보처리방침'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalDataRulePage(),
                ),
              );
            },
          ),
          const Divider(thickness: 8, color: AppColors.systemGrey4),
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
