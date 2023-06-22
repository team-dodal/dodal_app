import 'package:flutter/material.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('그룹 생성')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
