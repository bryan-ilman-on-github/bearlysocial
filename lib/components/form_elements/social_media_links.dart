import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/social_media_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaLink extends StatelessWidget {
  final SocialMedia platform;
  final TextEditingController? controller;

  const SocialMediaLink({
    super.key,
    required this.platform,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle? linkStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).focusColor,
            );

    final Widget svgIcon = SvgPicture.asset(
      'assets/svgs/${platform.icon}',
      width: SideSize.small,
      height: SideSize.small,
      color: Theme.of(context).focusColor,
    );

    final Widget warningIcon = SvgPicture.asset(
      'assets/svgs/warning_icon.svg',
      width: SideSize.small,
      height: SideSize.small,
      color: Theme.of(context).focusColor,
    );

    final Widget linkText = controller == null
        ? Text(
            platform.domain,
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Theme.of(context).indicatorColor,
            ),
          )
        : TextField(
            controller: controller,
            style: linkStyle,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: 'Type your username here.',
              hintStyle: linkStyle,
            ),
          );

    return GestureDetector(
      onTap: () => controller == null
          ? launchUrl(
              Uri.parse(platform.domain),
              mode: LaunchMode.externalApplication,
            )
          : null,
      onLongPress: () => controller == null
          ? Clipboard.setData(ClipboardData(text: platform.domain))
          : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: PaddingSize.verySmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Unverified',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(
              PaddingSize.verySmall,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              border: Border.all(
                color: Colors.transparent,
                width: ThicknessSize.medium,
              ),
              borderRadius: BorderRadius.circular(
                CurvatureSize.large,
              ),
            ),
            child: Row(
              children: [
                svgIcon,
                const SizedBox(
                  width: WhiteSpaceSize.verySmall,
                ),
                Expanded(
                  child: linkText,
                ),
                warningIcon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
