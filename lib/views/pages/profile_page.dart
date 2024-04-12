import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final ScrollController controller;

  const ProfilePage({
    super.key,
    required this.controller,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
