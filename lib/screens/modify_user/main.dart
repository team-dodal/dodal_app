import 'dart:io';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/services/user/service.dart';
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
  String? _imageUrl;
  File? _uploadImage;
  bool nicknameChecked = true;
  List<Tag> _category = [];

  _dismissKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  _submit() async {
    User? res = await UserService.updateUser(
      nickname: nicknameController.text,
      profileUrl: _imageUrl,
      profile: _uploadImage,
      content: contentController.text,
      category: _category.map((e) => e.value as String).toList(),
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
          tagList: res.tagList,
        ));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    final user = BlocProvider.of<UserCubit>(context).state!;
    nicknameController.text = user.nickname;
    contentController.text = user.content;
    setState(() {
      _category = user.tagList;
      _imageUrl = user.profileUrl;
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
        child: GestureDetector(
          onTap: () {
            _dismissKeyboard(context);
          },
          child: Column(
            children: [
              InputFormContent(
                nicknameController: nicknameController,
                contentController: contentController,
                imageUrl: _imageUrl,
                uploadImage: _uploadImage,
                setImage: (image) {
                  setState(() {
                    _imageUrl = null;
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
      ),
    );
  }
}
