import 'package:dodal_app/screens/group_route/main.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return const GroupRoute();
        }));
      },
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(children: [Text('title')]),
              Row(children: [Text('sub title')]),
            ],
          ),
        ),
      ),
    );
  }
}
