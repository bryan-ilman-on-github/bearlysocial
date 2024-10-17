import 'package:bearlysocial/views/buttons/setting_btn.dart';
import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/providers/auth_details/auth_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final ScrollController controller;

  const SettingsPage({
    super.key,
    required this.controller,
  });

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: widget.controller,
        padding: const EdgeInsets.all(
          PaddingSize.medium,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingButton(
              icon: Icons.translate,
              label: TranslationKey.translationButton.name.tr(),
              callbackFunction: () {},
            ),
            SettingButton(
              icon: Icons.delete_outlined,
              label: TranslationKey.deleteAccountButton.name.tr(),
              callbackFunction: ref.read(deleteAccount),
              splashColor: AppColor.lightRed,
              contentColor: AppColor.heavyRed,
            ),
            const SizedBox(
              height: WhiteSpaceSize.medium,
            ),
            SplashButton(
              verticalPadding: PaddingSize.small,
              callbackFunction: ref.read(exitApp),
              buttonColor: Colors.transparent,
              borderColor: AppColor.heavyRed,
              borderRadius: BorderRadius.circular(
                CurvatureSize.large,
              ),
              splashColor: AppColor.lightRed,
              child: Text(
                TranslationKey.signOutButton.name.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.heavyRed,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
