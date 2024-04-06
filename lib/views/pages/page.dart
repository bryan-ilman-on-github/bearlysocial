import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  final ScrollController controller;

  const SessionsPage({
    super.key,
    required this.controller,
  });

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
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
