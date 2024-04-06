import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

/// [NavigationBar] is a [StatelessWidget] that displays the app's main navigation bar.
class NavigationBar extends StatelessWidget {
  final Map<String, Map<String, dynamic>> navItems;
  final int selectedIndex;
  final Function onTap;

  const NavigationBar({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: navItems.entries.map((entry) {
          return _navItemBuilder(
            context: context,
            label: entry.key,
            normalIcon: entry.value['normalIcon'],
            highlightedIcon: entry.value['highlightedIcon'],
            controller: entry.value['controller'],
            index: entry.value['index'],
          );
        }).toList(),
      ),
    );
  }

  Widget _navItemBuilder({
    required BuildContext context,
    required String label,
    required IconData normalIcon,
    required IconData highlightedIcon,
    required ScrollController controller,
    required int index,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onTap(
            index: index,
            controller: controller,
          );
        },
        child: SizedBox(
          height: SideSize.medium,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selectedIndex == index ? highlightedIcon : normalIcon,
                color: selectedIndex == index
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(
                height: WhiteSpaceSize.verySmall,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: TextSize.verySmall,
                      fontWeight: selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selectedIndex == index
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
