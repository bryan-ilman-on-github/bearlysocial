import 'package:bearlysocial/utils/form_util.dart';
import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class Selector extends StatelessWidget {
  final String hint;
  final List<DropdownMenuEntry> menu;
  final TextEditingController controller;
  final List<String> entries;
  final Function addEntry;
  final Function removeEntry;

  const Selector({
    super.key,
    required this.hint,
    required this.menu,
    required this.controller,
    required this.entries,
    required this.addEntry,
    required this.removeEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownMenu(
              width: SideSize.veryLarge,
              hintText: hint,
              dropdownMenuEntries: menu,
              controller: controller,
              enableFilter: true,
              requestFocusOnTap: true,
              trailingIcon: const Icon(Icons.keyboard_arrow_down),
            ),
            const SizedBox(width: WhiteSpaceSize.verySmall),
            SplashButton(
              width: 58.0,
              height: 58.0,
              callbackFunction: () => addEntry(),
              borderRadius: BorderRadius.circular(CurvatureSize.infinity),
              shadow: Shadow.medium,
              child: Icon(
                Icons.add,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
        if (entries.isNotEmpty) ...[
          const SizedBox(height: WhiteSpaceSize.small),
          const Text('Tap to remove.'),
          const SizedBox(height: WhiteSpaceSize.small / 2),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: MarginSize.veryLarge,
            runSpacing: MarginSize.veryLarge,
            children: FormUtility.buildTags(
              labels: entries,
              removeEntry: removeEntry,
            ),
          ),
        ],
      ],
    );
  }
}
