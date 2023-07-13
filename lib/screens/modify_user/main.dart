import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/modify_user/input_form_content.dart';
import 'package:dodal_app/widgets/modify_user/tag_select_content.dart';
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
  bool nicknameChecked = true;
  List<String> _category = [];

  _submit() async {
    // var res = await UserService.updateUser(
    //   nickname: nicknameController.text,
    //   profile: profile,
    //   content: contentController.text,
    //   category: category,
    // );
  }

  @override
  void initState() {
    final user = BlocProvider.of<MyInfoCubit>(context).state!;
    nicknameController.text = user.nickname;
    contentController.text = user.content;
    setState(() {
      _category = user.tagList.map((tag) => '${tag.value}').toList();
    });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 설정'),
        actions: [
          TextButton(
            onPressed: nicknameChecked && _category.isNotEmpty ? _submit : null,
            child: const Text('저장'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            InputFormContent(
              nicknameController: nicknameController,
              contentController: contentController,
              nicknameChecked: nicknameChecked,
              setNicknameChecked: (value) {
                setState(() {
                  nicknameChecked = value;
                });
              },
            ),
            Container(
              width: double.infinity,
              height: 8,
              decoration: const BoxDecoration(color: AppColors.systemGrey4),
            ),
            TagSelectContent(
              itemList: _category,
              setItemList: (value) {
                setState(() {
                  _category = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
