import 'package:dodal_app/widgets/home/category_select.dart';
import 'package:dodal_app/widgets/home/interest_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CategorySelect(),
          const SizedBox(height: 32),
          const InterestList(),
        ],
      ),
    );
  }
}
