import 'package:animations/animations.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/screens/challenge_preview/main.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/common/challenge_box/grid_challenge_box.dart';
import 'package:flutter/material.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Challenge> _challenges = [];

  getList() async {
    final list = await ChallengeService.getBookmarkList();
    if (list == null) return;
    setState(() {
      _challenges = list;
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 20,
          shrinkWrap: true,
          childAspectRatio: 0.8,
          children: [
            for (final challenge in _challenges)
              OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedElevation: 0,
                closedBuilder: (context, action) {
                  return Container(
                      padding: const EdgeInsets.only(top: 20),
                      constraints: const BoxConstraints(minHeight: 80),
                      child: GridChallengeBox(challenge: challenge));
                },
                openBuilder: (context, action) => challenge.isJoined
                    ? ChallengeRoute(id: challenge.id)
                    : ChallengePreviewScreen(id: challenge.id),
              )
          ],
        ),
      ),
    );
  }
}
