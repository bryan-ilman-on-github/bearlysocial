import 'package:bearlysocial/components/lines/horizontal_line.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool displayBadge;
  final Function() callbackFunction;
  final Color? splashColor;
  final Color? contentColor;

  /// [SettingButton] is a [StatelessWidget] representing a button used in [SettingsPage].
  /// It consists of an icon and a label, and triggers a callback function when tapped.
  const SettingButton({
    super.key,
    required this.icon,
    required this.label,
    this.displayBadge = false,
    required this.callbackFunction,
    this.splashColor,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CurvatureSize.small),
          ),
          child: InkWell(
            onTap: callbackFunction.call,
            splashColor: splashColor,
            borderRadius: BorderRadius.circular(CurvatureSize.small),
            child: Padding(
              padding: const EdgeInsets.all(
                PaddingSize.medium,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: contentColor,
                  ),
                  const SizedBox(
                    width: WhiteSpaceSize.small,
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: contentColor,
                          ),
                    ),
                  ),
                  if (displayBadge) ...[
                    const Icon(
                      Icons.circle,
                      size: IconSize.small,
                      color: AppColor.heavyRed,
                    ),
                    const SizedBox(
                      width: WhiteSpaceSize.verySmall,
                    ),
                  ],
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: contentColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        const HorizontalLine(
          horizontalMargin: MarginSize.medium,
        ),
      ],
    );
  }
}
