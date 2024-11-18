import 'package:bearlysocial/providers/statuses_pod.dart';
import 'package:bearlysocial/views/buttons/setting_btn.dart';
import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final ScrollController scroller;

  const SettingsPage({
    super.key,
    required this.scroller,
  });

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final GlobalKey _settingButtonKey = GlobalKey();
  double? _settingButtonHeight;

  @override
  void initState() {
    super.initState();
    // Wait until the first frame to calculate the height
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final buttonContext = _settingButtonKey.currentContext;
      if (buttonContext != null) {
        setState(() {
          _settingButtonHeight = buttonContext.size?.height;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: widget.scroller,
        padding: const EdgeInsets.all(PaddingSize.medium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SettingButton(
              key: _settingButtonKey,
              icon: Icons.translate,
              label: TranslationKey.translationButton.name.tr(),
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
              height: WhiteSpaceSize.medium,
            ),
            SplashButton(
              verticalPadding: PaddingSize.small,
              callbackFunction: () => ref.read(setAuthStatus)(false),
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
