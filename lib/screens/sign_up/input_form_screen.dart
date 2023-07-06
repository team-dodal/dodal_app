import 'package:flutter/material.dart';

import '../../helper/validator.dart';
import '../../services/user_service.dart';
import '../../widgets/common/system_dialog.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({
    super.key,
    required this.nextStep,
    required this.step,
  });

  final Function nextStep;
  final int step;

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _nicknameChecked = false;
  String _nickname = '';
  String _content = '';

  _checkingNickname() async {
    final res = await UserService.checkNickName(_nickname);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => SystemDialog(
        title: res ? '사용할 수 있는 닉네임입니다.' : '사용할 수 없는 닉네임입니다.',
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
    setState(() {
      _nicknameChecked = res;
    });
  }

  _handleNextStep() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.nextStep({
      'nickname': _nickname,
      'content': _content,
      'image': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text('${widget.step} / 2'),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '닉네임'),
                    onChanged: (value) {
                      _nickname = value;
                    },
                    validator: (value) =>
                        Validator.signUpNickname(value, _nicknameChecked),
                  ),
                ),
                ElevatedButton(
                  onPressed: _checkingNickname,
                  child: Text(_nicknameChecked ? '확인 완료' : '중복 확인'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            decoration: const InputDecoration(labelText: '한 줄 소개'),
            onSaved: (value) {
              _content = value!;
            },
            validator: Validator.signUpContent,
          ),
          FloatingActionButton(
            onPressed: _handleNextStep,
            child: const Text('다음'),
          ),
        ],
      ),
    );
  }
}
