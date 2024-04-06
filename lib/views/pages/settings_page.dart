import 'package:bearlysocial/components/pictures/profile_pic.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/providers/auth_state.dart';
import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/buttons/setting_btn.dart';
import 'package:bearlysocial/providers/personal_info_saving_state.dart';
import 'package:bearlysocial/views/sheets/personal_info_sheet.dart';
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
            const ProfilePicture(),
            const SizedBox(
              height: WhiteSpaceSize.medium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mark Zuckerberg',
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(
              height: MarginSize.veryLarge,
            ),
            SettingButton(
              icon: Icons.person_outlined,
              label: TranslationKey.personalInformationButton.name.tr(),
              displayBadge: ref.watch(isPersonalInfoEdited),
              callbackFunction: () {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return PersonalInformation();
                  },
                );
              },
            ),
            SettingButton(
              icon: Icons.translate,
              label: TranslationKey.translationButton.name.tr(),
              callbackFunction: () {},
            ),
            SettingButton(
              icon: Icons.notifications_outlined,
              label: TranslationKey.notificationsButton.name.tr(),
              callbackFunction: () {},
            ),
            SettingButton(
              icon: Icons.cloud_download_outlined,
              label: TranslationKey.requestPersonalDataButton.name.tr(),
              callbackFunction: () {},
            ),
            SettingButton(
              icon: Icons.delete_outlined,
              label: TranslationKey.deleteAccountButton.name.tr(),
              callbackFunction: () {},
              splashColor: AppColor.lightRed,
              contentColor: AppColor.heavyRed,
            ),
            const SizedBox(
              height: WhiteSpaceSize.veryLarge,
            ),
            SettingButton(
              icon: Icons.help_outline_outlined,
              label: TranslationKey.helpCenterButton.name.tr(),
              callbackFunction: () {},
            ),
            SettingButton(
              icon: Icons.menu_book,
              label: TranslationKey.termsOfServiceButton.name.tr(),
              callbackFunction: () {},
            ),
            SettingButton(
              icon: Icons.menu_book,
              label: TranslationKey.privacyPolicyButton.name.tr(),
              callbackFunction: () {},
            ),
            const SizedBox(
              height: WhiteSpaceSize.medium,
            ),
            SplashButton(
              verticalPadding: PaddingSize.small,
              callbackFunction: ref.watch(exitApp),
              buttonColor: Colors.transparent,
              borderColor: Colors.transparent,
              borderRadius: BorderRadius.circular(
                CurvatureSize.large,
              ),
              splashColor: AppColor.lightRed,
              child: Text(
                TranslationKey.signOutButton.name.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColor.heavyRed,
                    ),
              ),
            ),
            const SizedBox(
              height: WhiteSpaceSize.verySmall,
            ),
          ],
        ),
      ),
    );
  }
}
