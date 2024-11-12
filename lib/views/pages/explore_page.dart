import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  final ScrollController scroller;

  const ExplorePage({
    super.key,
    required this.scroller,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Widget> _children = [];

  @override
  Widget build(context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          controller: widget.scroller,
          itemCount: _children.length,
          itemBuilder: (BuildContext _, int index) => _children[index],
        ),
      ),
    );
  }
}
