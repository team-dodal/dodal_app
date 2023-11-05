import 'package:dodal_app/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/screens/report/main.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class ReportBottomSheet extends StatelessWidget {
  const ReportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: Column(
        children: [
          ListTile(
            title: Text('신고하기', style: context.body2()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ReportScreen();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
