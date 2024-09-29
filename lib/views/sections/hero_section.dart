import 'dart:convert';

import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/form_elements/underlined_txt_field.dart';
import 'package:bearlysocial/components/lines/progress_spinner.dart';
import 'package:bearlysocial/constants/cloud_details.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/providers/auth_details/auth_page_email_addr_state.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_status_code/http_status_code.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection> {
  bool _blockInput = false;

  final FocusNode _emailAddrFocusNode = FocusNode();
  final TextEditingController _emailAddrController = TextEditingController();

  String? _emailAddrErrTxt;

  @override
  void initState() {
    super.initState();

    _emailAddrFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailAddrFocusNode.dispose();
    super.dispose();
  }

  void _requestOTP() async {
    final String emailAddr = _emailAddrController.text;

    await CloudUtility.sendRequest(
      onSuccess: ,
      onBadRequest: ,
      image: ,
      endpoint: DigitalOceanFunctionsAPI.requestOTP,
      body: {
        'email_address': emailAddr,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _emailAddrErrTxt = null;
      });
      ref.read(setAuthPageEmailAddr)(emailAddr: emailAddr);
    } else {
      setState(() {
        _emailAddrErrTxt = jsonDecode(response.body)['message'];
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
          enabled: ref.watch(authPageEmailAddr).isEmpty,
          label: TranslationKey.emailAddrLabel.name.tr(),
          controller: _emailAddrController,
          focusNode: _emailAddrFocusNode,
          errorText: _emailAddrErrTxt,
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
          callbackFunction: ref.watch(authPageEmailAddr).isEmpty
              ? _blockInput
                  ? null
                  : () {
                      _blockInput = true;
                      _requestOTP();
                    }
              : null,
          shadow: Shadow.medium,
          child: _blockInput
              ? const ProgressSpinner(
                  invertColor: true,
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
