import 'package:bearlysocial/aliases/app_scope.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final Map<String, Map<String, dynamic>> navItems;
  final int index;
  final Function({
    required int index,
    required ScrollController scroller,
  }) onTap;

  const NavigationBar({
    super.key,
    required this.navItems,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(context context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [Shadow.small],
      ),
      child: Row(
        children: navItems.entries.map((entry) {
          return _navItemBuilder(context: context, entry: entry);
        }).toList(),
      ),
    );
  }

  Widget _navItemBuilder({
    required context context,
    required MapEntry<String, Map<String, dynamic>> entry,
  }) {
    final isActive = entry.value['index'] == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onTap(
            index: entry.value['index'],
            scroller: entry.value['scroller'],
          );
        },
        child: SizedBox(
          height: SideSize.medium,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive
                    ? entry.value['highlightedIcon']
                    : entry.value['normalIcon'],
                color: isActive
                    ? Theme.of(context).focusColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
              const SizedBox(height: WhiteSpaceSize.verySmall),
              Text(
                entry.key,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: TextSize.verySmall,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive
                          ? Theme.of(context).focusColor
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
