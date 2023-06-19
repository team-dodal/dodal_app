import 'package:dodal_app/widgets/common/team_card.dart';
import 'package:flutter/material.dart';

final _list = List.filled(20, 0);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return const TeamCard();
      },
    );
  }
}
