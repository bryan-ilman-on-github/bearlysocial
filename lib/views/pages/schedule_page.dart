import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  final ScrollController controller;

  const SchedulePage({
    super.key,
    required this.controller,
  });

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          controller: widget.controller,
          itemCount: _children.length,
          itemBuilder: (BuildContext context, int index) => _children[index],
        ),
      ),
    );
  }
}
