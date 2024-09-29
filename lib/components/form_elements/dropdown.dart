import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/utils/dropdown_operation.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final List<DropdownMenuEntry> menu;
  final List<String> collection;
  final Function addLabel;
  final Function removeLabel;

  /// [Dropdown] is a [StatelessWidget] for creating a dropdown with an associated list of tags.
  const Dropdown({
    super.key,
    required this.hint,
    required this.controller,
    required this.menu,
    required this.collection,
    required this.addLabel,
    required this.removeLabel,
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
              controller: controller,
              dropdownMenuEntries: menu,
              enableFilter: true,
              requestFocusOnTap: true,
              trailingIcon: const Icon(
                Icons.keyboard_arrow_down,
              ),
            ),
            const SizedBox(
              width: WhiteSpaceSize.verySmall,
            ),
            SplashButton(
              width: 58.0,
              height: 58.0,
              callbackFunction: () => addLabel(),
              borderRadius: BorderRadius.circular(
                CurvatureSize.infinity,
              ),
              shadow: Shadow.medium,
              child: Icon(
                Icons.add,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
        if (collection.isNotEmpty) ...[
          const SizedBox(
            height: WhiteSpaceSize.small,
          ),
          const Text(
            'Tap to remove.',
          ),
          const SizedBox(
            height: WhiteSpaceSize.small / 2,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: MarginSize.veryLarge,
            runSpacing: MarginSize.veryLarge,
            children: DropdownOperation.buildTags(
              collection: collection,
              callbackFunction: removeLabel,
            ),
          )
        ],
      ],
    );
  }
}
