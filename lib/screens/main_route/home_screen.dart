import 'package:dodal_app/widgets/home/category_select.dart';
import 'package:dodal_app/widgets/home/interest_list.dart';
import 'package:dodal_app/widgets/home/popular_list.dart';
import 'package:dodal_app/widgets/home/recent_list.dart';
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
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          children: [
            CategorySelect(),
            const SizedBox(height: 32),
            const InterestList(),
            const SizedBox(height: 32),
            const PopularList(),
            const SizedBox(height: 48),
            const RecentList(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
