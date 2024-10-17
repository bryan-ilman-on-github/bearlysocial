// ignore_for_file: camel_case_types

import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/social_media_consts.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

typedef local_db = LocalDatabaseUtility;

class SocialMediaLink extends StatelessWidget {
  final TextEditingController controller;
  final SocialMedia platform;
  final String? handle;

  const SocialMediaLink({
    super.key,
    required this.controller,
    required this.platform,
    this.handle,
  });

  @override
  Widget build(BuildContext context) {
    controller.text =
        handle ?? local_db.retrieveTransaction(key: '${platform.name}_handle');

    dynamic peerVerificationCount = local_db.retrieveTransaction(
      key: '${platform.name}_peer_verification_count',
    );

    if (peerVerificationCount.isNotEmpty) {
      peerVerificationCount = int.parse(peerVerificationCount);
    }

    final TextStyle? linkStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Theme.of(context).focusColor);

    final Widget linkText = handle == null
        ? TextField(
            controller: controller,
            style: linkStyle,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: 'Type your username here.',
              hintStyle: linkStyle,
            ),
          )
        : Text(
            handle!.isEmpty ? '-' : handle as String,
            style: TextStyle(color: Theme.of(context).indicatorColor),
          );

    final Widget platformIcon = SvgPicture.asset(
      'assets/svgs/${platform.icon}',
      width: SideSize.small,
      height: SideSize.small,
      color: Theme.of(context).focusColor,
    );

    final Widget verficationIcon = controller.text.isNotEmpty
        ? SvgPicture.asset(
            peerVerificationCount <= 4
                ? 'assets/svgs/warning_icon.svg'
                : 'assets/svgs/circle_check_icon.svg',
            width: SideSize.small,
            height: SideSize.small,
            color: Theme.of(context).focusColor,
          )
        : const SizedBox();

    return GestureDetector(
      onTap: () => handle != null
          ? launchUrl(
              Uri.parse(platform.domain + handle!),
              mode: LaunchMode.externalApplication,
            )
          : null,
      onLongPress: () => handle != null
          ? Clipboard.setData(ClipboardData(text: platform.domain + handle!))
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
                  controller.text.isNotEmpty
                      ? '$peerVerificationCount peer verification(s)'
                      : '', // TODO: check this!
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(PaddingSize.verySmall),
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              border: Border.all(
                color: Theme.of(context).focusColor,
                width: ThicknessSize.medium,
              ),
              borderRadius: BorderRadius.circular(CurvatureSize.large),
            ),
            child: Row(
              children: [
                platformIcon,
                const SizedBox(width: WhiteSpaceSize.verySmall),
                Expanded(child: linkText),
                verficationIcon, // TODO: check this!
              ],
            ),
          ),
        ],
      ),
    );
  }
}
