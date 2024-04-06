import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String label;
  final Function callbackFunction;

  /// [Tag] is a [StatelessWidget] representing a tag element.
  const Tag({
    super.key,
    required this.label,
    required this.callbackFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callbackFunction(
          labelToRemove: label,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(
          PaddingSize.verySmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(
            CurvatureSize.small,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.circle,
              size: IconSize.small,
            ),
            const SizedBox(
              width: MarginSize.small,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
