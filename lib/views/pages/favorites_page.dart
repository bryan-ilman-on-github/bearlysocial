import 'package:bearlysocial/aliases/app_scope.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final ScrollController scroller;

  const FavoritesPage({
    super.key,
    required this.scroller,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<Widget> _children = [];

  @override
  Widget build(AppScope context) {
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
