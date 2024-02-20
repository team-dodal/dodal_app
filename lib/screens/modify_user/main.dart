import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/modify_user_cubit.dart';
import 'package:dodal_app/providers/nickname_check_bloc.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/category_tag_select.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/modify_user/input_form_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyUserScreen extends StatefulWidget {
  const ModifyUserScreen({super.key});

  @override
  State<ModifyUserScreen> createState() => _ModifyUserScreenState();
}

class _ModifyUserScreenState extends State<ModifyUserScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool _isLoading = false;

  _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  bool _submitButtonDisabled() {
    if (context.read<NicknameBloc>().state.status != NicknameStatus.success) {
      return true;
    }
    if (_isLoading) return true;
    return false;
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    User? res = await context.read<ModifyUserCubit>().modifyUser();
    if (res == null) return;
    print(res);
    context.read<UserBloc>().add(UpdateUserBlocEvent(res));
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    final user = BlocProvider.of<ModifyUserCubit>(context).state;
    nicknameController.text = user.nickname;
    contentController.text = user.content;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    nicknameController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModifyUserCubit, ModifyUserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('프로필 설정'),
            actions: [
              TextButton(
                onPressed: _submitButtonDisabled() ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('저장'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: GestureDetector(
              onTap: _dismissKeyboard,
              child: Column(
                children: [
                  InputFormContent(
                    nicknameController: nicknameController,
                    contentController: contentController,
                  ),
                  const Divider(thickness: 8, color: AppColors.systemGrey4),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 20),
                    child: Column(
                      children: [
                        const CreateFormTitle(
                          title: '무엇에 관심 있나요?',
                          subTitle: '1개 이상 선택하시면 딱 맞는 도전들을 추천드려요!',
                        ),
                        const SizedBox(height: 34),
                        CategoryTagSelect(
                          selectedList: state.category,
                          onChange: context.read<ModifyUserCubit>().handleTag,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
