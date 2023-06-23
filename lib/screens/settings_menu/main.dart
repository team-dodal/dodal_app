import 'package:dodal_app/utilities/fcm.dart';
import 'package:flutter/material.dart';

class SettingsMenuScreen extends StatefulWidget {
  const SettingsMenuScreen({super.key});

  @override
  State<SettingsMenuScreen> createState() => _SettingsMenuScreenState();
}

class _SettingsMenuScreenState extends State<SettingsMenuScreen> {
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
            value: Fcm.isAllow,
            onChanged: (value) {
              setState(() {
                value ? Fcm.requestPermission() : Fcm.isAllow = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
