import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../../model/tag_model.dart';
import '../../services/category_service.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({
    super.key,
    required this.step,
    required this.nextStep,
  });

  final int step;
  final Function nextStep;

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  final Future<dynamic> _categories = CategoryService.getAllCategories();
  _handleNextStep() async {
    widget.nextStep({
      "category": ["001001", "002003", "004001"]
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _categories,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Placeholder();
            }
            final List<Category> categories = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  for (Category category in categories)
                    Column(
                      children: [
                        Text(category.name),
                        Wrap(
                          children: [
                            for (Tag tag in category.tags)
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('${tag.name}'),
                              )
                          ],
                        )
                      ],
                    )
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: SafeArea(
        child: SizedBox(
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: _handleNextStep,
            child: const Text('다음'),
          ),
        ),
      ),
    );
  }
}
