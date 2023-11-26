import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/widgets/common/cross_divider.dart';
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
  dynamic _uploadImage;
  bool nicknameChecked = true;
  List<Tag> _category = [];
  bool _isLoading = false;

  _dismissKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    User? res = await UserService.updateUser(
      nickname: nicknameController.text,
      profile: _uploadImage,
      content: contentController.text,
      tagList: _category.map((e) => e.value as String).toList(),
    );
    if (res == null) return;
    if (!mounted) return;
    context.read<UserCubit>().set(User(
          id: res.id,
          email: res.email,
          nickname: res.nickname,
          content: res.content,
          profileUrl: res.profileUrl,
          registerAt: res.registerAt,
          socialType: res.socialType,
          categoryList: res.categoryList,
          tagList: res.tagList,
        ));
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    final user = BlocProvider.of<UserCubit>(context).state!;
    nicknameController.text = user.nickname;
    contentController.text = user.content;

    setState(() {
      _category = user.tagList;
      _uploadImage = user.profileUrl;
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
          !_isLoading
              ? TextButton(
                  onPressed:
                      nicknameChecked && _category.isNotEmpty ? _submit : null,
                  child: const Text('저장'),
                )
              : const TextButton(
                  onPressed: null,
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: GestureDetector(
          onTap: () {
            _dismissKeyboard(context);
          },
          child: Column(
            children: [
              InputFormContent(
                nicknameController: nicknameController,
                contentController: contentController,
                image: _uploadImage,
                setImage: (image) {
                  setState(() {
                    _uploadImage = image;
                  });
                },
                nicknameChecked: nicknameChecked,
                setNicknameChecked: (value) {
                  setState(() {
                    nicknameChecked = value;
                  });
                },
              ),
              const CrossDivider(),
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
      ),
    );
  }
}
