import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/form_elements/underlined_txt_field.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/endpoint.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/providers/auth_page_email_address_state.dart';
import 'package:bearlysocial/utilities/api.dart';
import 'package:bearlysocial/utilities/form_management.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection> {
  bool _blockInput = false;

  final FocusNode _emailAddressFocusNode = FocusNode();
  final TextEditingController _emailAddressController = TextEditingController();

  String? _emailAddressErrorText;

  @override
  void initState() {
    super.initState();

    _emailAddressFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailAddressFocusNode.dispose();

    super.dispose();
  }

  void _continue() async {
    _blockInput = true;

    final String emailAddress = _emailAddressController.text;

    bool emailAddressIsvalid = FormManagement.validateEmailAddress(
      emailAddress: emailAddress,
    );

    if (emailAddressIsvalid) {
      setState(() {
        _emailAddressErrorText = null;
      });

      ref.read(setAuthenticationPageEmailAddress)(emailAddress: emailAddress);
    } else {
      setState(() {
        _emailAddressErrorText = 'Please type your valid email address.';
      });
    }

    _blockInput = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 80,
              child: Text(
                'Step in and explore!',
                maxLines: 2,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const Expanded(
              flex: 20,
              child: SizedBox(),
            ),
          ],
        ),
        const SizedBox(
          height: WhiteSpaceSize.veryLarge,
        ),
        UnderlinedTextField(
          label: TranslationKey.emailAddressLabel.name.tr(),
          controller: _emailAddressController,
          focusNode: _emailAddressFocusNode,
          errorText: _emailAddressErrorText,
        ),
        const SizedBox(
          height: WhiteSpaceSize.large,
        ),
        SplashButton(
          width: double.infinity,
          verticalPadding: PaddingSize.small,
          borderRadius: BorderRadius.circular(
            CurvatureSize.large,
          ),
          callbackFunction: _blockInput ? null : _continue,
          shadow: Shadow.medium,
          child: _blockInput
              ? SizedBox(
                  width: SideSize.verySmall,
                  height: SideSize.verySmall,
                  child: CircularProgressIndicator(
                    strokeWidth: ThicknessSize.large,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                )
              : Text(
                  'Continue',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
        ),
      ],
    );
  }
}