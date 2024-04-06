import 'package:bearlysocial/components/cards/profile_card.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
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
  final List<Widget> _children = [
    ProfileCard(
      name: 'Larry Page',
      rating: 4.2,
      location: 'Jakarta, Indonesia',
      interests: ['Football'],
    ),
    const SizedBox(
      height: 20,
    ),
    ProfileCard(
      name: 'Larry Page',
      rating: 4.2,
      location: 'Jakarta, Indonesia',
      interests: ['Football'],
    ),
    const SizedBox(
      height: 20,
    ),
    ProfileCard(
      name: 'Larry Page',
      rating: 4.2,
      location: 'Jakarta, Indonesia',
      interests: ['Football'],
    ),
    const SizedBox(
      height: 20,
    ),
    ProfileCard(
      name: 'Larry Page',
      rating: 4.2,
      location: 'Jakarta, Indonesia',
      interests: ['Football'],
    ),
    const SizedBox(
      height: 20,
    ),
    ProfileCard(
      name: 'Larry Page',
      rating: 4.2,
      location: 'Jakarta, Indonesia',
      interests: ['Football'],
    ),
    const SizedBox(
      height: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingSize.small,
        ),
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
