import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  final ScrollController controller;

  const ExplorePage({
    super.key,
    required this.controller,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
