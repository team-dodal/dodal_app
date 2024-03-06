import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/modify_user_cubit.dart';
import 'package:dodal_app/providers/nickname_check_bloc.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/category_tag_select.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
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

  void _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  bool _submitButtonDisabled() {
    if (context.read<NicknameBloc>().state.status != CommonStatus.loaded) {
      return true;
    }
    if (context.read<ModifyUserCubit>().state.status == CommonStatus.loading) {
      return true;
    }
    return false;
  }

  void _success(User user) async {
    context.read<UserBloc>().add(UpdateUserBlocEvent(user));
    Navigator.of(context).pop(true);
  }

  void _error(String errorMessage) async {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(subTitle: errorMessage),
    );
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
    return BlocConsumer<ModifyUserCubit, ModifyUserState>(
      listener: (context, state) {
        if (state.status == CommonStatus.loaded) {
          _success(state.response!);
        }
        if (state.status == CommonStatus.error) {
          _error(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('프로필 설정'),
            actions: [
              TextButton(
                onPressed: _submitButtonDisabled()
                    ? null
                    : () {
                        context.read<ModifyUserCubit>().modifyUser();
                      },
                child: state.status == CommonStatus.loading
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
