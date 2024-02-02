import 'package:dodal_app/providers/create_user_cubit.dart';
import 'package:dodal_app/providers/sign_in_bloc.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/screens/sign_up/complete_screen.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:dodal_app/widgets/common/category_tag_select.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({
    super.key,
    required this.step,
    required this.steps,
  });

  final int step;
  final int steps;

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> _submit() async {
    final res = await context.read<CreateUserCubit>().createUser();
    if (res == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => BlocProvider(
            create: (context) => SignInBloc(
              googleAuthService: GoogleAuthService(),
              appleAuthService: AppleAuthService(),
              kakaoAuthService: KakaoAuthService(),
              secureStorage: const FlutterSecureStorage(),
            ),
            child: const SignInScreen(),
          ),
        ),
        (route) => false,
      );
    } else {
      await secureStorage.write(
        key: 'accessToken',
        value: res["accessToken"],
      );
      await secureStorage.write(
        key: 'refreshToken',
        value: res["refreshToken"],
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const CompleteSignUpScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateUserCubit, CreateUserState>(
        builder: (context, createUser) {
      return Scaffold(
        appBar: AppBar(title: const Text('프로필 설정')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreateFormTitle(
                  title: '무엇에 관심 있나요?',
                  subTitle: '1개 이상 선택하시면 딱 맞는 도전들을 추천드려요!',
                  currentStep: widget.step,
                  steps: widget.steps,
                ),
                const SizedBox(height: 40),
                CategoryTagSelect(
                  selectedList: createUser.category,
                  onChange: context.read<CreateUserCubit>().handleTag,
                ),
                const Center(
                  child: Text(
                    '관심사는 나중에 다시 수정할 수 있어요!',
                    style: TextStyle(color: AppColors.systemGrey2),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomSheet: SubmitButton(
          title: '완료',
          onPress: createUser.category.isEmpty ? null : _submit,
        ),
      );
    });
  }
}
