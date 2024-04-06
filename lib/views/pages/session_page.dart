import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/views/pages/explore_page.dart';
import 'package:bearlysocial/views/pages/favorites_page.dart';
import 'package:bearlysocial/components/bars/nav_bar.dart' as app_nav_bar;
import 'package:bearlysocial/views/pages/page.dart';
import 'package:bearlysocial/views/pages/settings_page.dart';
import 'package:flutter/material.dart';

class SessionPage extends StatefulWidget {
  /// [SessionPage] is a [StatefulWidget] responsible for managing post-authentication pages,
  /// allowing users to navigate between various pages using an [IndexedStack].
  /// It features a [app_nav_bar.NavigationBar] and a [FloatingActionButton] for scrolling to the top.

  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPage();
}

class _SessionPage extends State<SessionPage> {
  List<Widget> _pages = [];

  int _selectedIndex = 0;

  late ScrollController _controller;
  bool _showingScrollButton = false;

  Map<String, Map<String, dynamic>> _navItems = {};

  ScrollController _createController() {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      setState(() {
        _showingScrollButton = scrollController.offset > 0.0;
      });
    });

    return scrollController;
  }

  void _scrollToTop() {
    _controller.animateTo(
      0.0,
      duration: const Duration(
        milliseconds: AnimationDuration.medium,
      ),
      curve: Curves.easeInOut,
    );
  }

  void _onTap({
    required int index,
    required ScrollController controller,
  }) {
    setState(() {
      _selectedIndex = index;
      _controller = controller;

      _showingScrollButton = _controller.offset > 0.0;
    });
  }

  List<Widget> _initPages() {
    return <Widget>[
      ExplorePage(
        controller: _createController(),
      ),
      FavoritesPage(
        controller: _createController(),
      ),
      SessionsPage(
        controller: _createController(),
      ),
      SettingsPage(
        controller: _createController(),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    _pages = _initPages();

    _navItems = {
      'Explore': {
        'normalIcon': Icons.explore_outlined,
        'highlightedIcon': Icons.explore,
      },
      'Favorites': {
        'normalIcon': Icons.favorite_border,
        'highlightedIcon': Icons.favorite,
      },
      'Sessions': {
        'normalIcon': Icons.calendar_today_outlined,
        'highlightedIcon': Icons.calendar_today,
      },
      'Settings': {
        'normalIcon': Icons.settings_outlined,
        'highlightedIcon': Icons.settings,
      },
    }.map((key, value) {
      var index = _pages.indexWhere(
        (page) => page.runtimeType.toString() == '${key}Page',
      );

      return MapEntry(key, {
        ...value,
        'controller': (_pages[index] as dynamic).controller,
        'index': index,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: _showingScrollButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              elevation: ElevationSize.small,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              mini: true,
              child: Icon(
                Icons.arrow_upward,
                color: Theme.of(context).dividerColor,
              ),
            )
          : null,
      bottomNavigationBar: app_nav_bar.NavigationBar(
        navItems: _navItems,
        selectedIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
