import 'package:bearlysocial/views/bars/nav_bar.dart' as app_nav_bar;
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/views/pages/explore_page.dart';
import 'package:bearlysocial/views/pages/favorites_page.dart';
import 'package:bearlysocial/views/pages/profile_page.dart';
import 'package:bearlysocial/views/pages/schedule_page.dart';
import 'package:bearlysocial/views/pages/settings_page.dart';
import 'package:flutter/material.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Map<String, Map<String, dynamic>> _routes = {};
  int _index = 0;

  List<Widget> _pages = [];

  late ScrollController _scroller;
  bool _showingScrollButton = false;

  ScrollController _createScrollController() {
    final scroller = ScrollController();

    scroller.addListener(() {
      setState(() => _showingScrollButton = scroller.offset > 0.0);
    });

    return scroller;
  }

  void _scrollToTop() {
    _scroller.animateTo(
      0.0,
      duration: const Duration(milliseconds: AnimationDuration.medium),
      curve: Curves.easeInOut,
    );
  }

  void _onTap({
    required int index,
    required ScrollController scroller,
  }) {
    setState(() {
      _index = index;
      _scroller = scroller;

      _showingScrollButton = _scroller.offset > 0.0;
    });
  }

  List<Widget> _initPages() {
    return <Widget>[
      ExplorePage(
        scroller: _createScrollController(),
      ),
      FavoritesPage(
        scroller: _createScrollController(),
      ),
      SchedulePage(
        scroller: _createScrollController(),
      ),
      ProfilePage(
        scroller: _createScrollController(),
      ),
      SettingsPage(
        scroller: _createScrollController(),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    _pages = _initPages();

    const normalIcon = 'normalIcon';
    const highlightedIcon = 'highlightedIcon';

    _routes = {
      'Explore': {
        normalIcon: Icons.explore_outlined,
        highlightedIcon: Icons.explore,
      },
      'Favorites': {
        normalIcon: Icons.favorite_border,
        highlightedIcon: Icons.favorite,
      },
      'Schedule': {
        normalIcon: Icons.calendar_today_outlined,
        highlightedIcon: Icons.calendar_today,
      },
      'Profile': {
        normalIcon: Icons.person_outlined,
        highlightedIcon: Icons.person,
      },
      'Settings': {
        normalIcon: Icons.settings_outlined,
        highlightedIcon: Icons.settings,
      },
    }.map((key, value) {
      final index = _pages.indexWhere(
        (page) => page.runtimeType.toString() == '${key}Page',
      );

      return MapEntry(key, {
        ...value,
        'scroller': (_pages[index] as dynamic).scroller,
        'index': index,
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: _showingScrollButton
          ? FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: ElevationSize.small,
              onPressed: _scrollToTop,
              mini: true,
              child: Icon(
                Icons.arrow_upward,
                color: Theme.of(context).dividerColor,
              ),
            )
          : null,
      bottomNavigationBar: app_nav_bar.NavigationBar(
        routes: _routes,
        index: _index,
        onTap: _onTap,
      ),
    );
  }
}
