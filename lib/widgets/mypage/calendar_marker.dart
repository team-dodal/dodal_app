import 'package:flutter/material.dart';

class CalendarMarker extends StatefulWidget {
  const CalendarMarker({super.key, required this.text});

  final String text;

  @override
  State<CalendarMarker> createState() => _CalendarMarkerState();
}

class _CalendarMarkerState extends State<CalendarMarker> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
