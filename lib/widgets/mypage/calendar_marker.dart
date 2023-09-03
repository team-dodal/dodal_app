import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class CalendarCell extends StatefulWidget {
  const CalendarCell({
    super.key,
    required this.text,
    this.backgroundColor,
  });

  final String text;
  final Color? backgroundColor;

  @override
  State<CalendarCell> createState() => _CalendarCellState();
}

class _CalendarCellState extends State<CalendarCell> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: Ink(
            child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: AppColors.systemGrey3, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: context.body1(
                fontWeight: FontWeight.bold,
                color: AppColors.systemGrey2,
              ),
            ),
          ),
        )),
      ),
    );
  }
}
