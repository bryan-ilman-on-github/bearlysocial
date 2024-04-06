import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/form_elements/underlined_txt_field.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/translation_key.dart';
import 'package:bearlysocial/utilities/form_management.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HookSection extends StatefulWidget {
  const HookSection({super.key});

  @override
  State<HookSection> createState() => _HookSectionState();
}

class _HookSectionState extends State<HookSection> {
  bool _showFirst = true;

  bool _blockInput = false;

  String? _emailErrorText;

  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();

    super.dispose();
  }

  void _continue() async {
    _blockInput = true;

    bool emailIsvalid = FormManagement.validateEmail(
      email: _emailController.text,
    );

    if (emailIsvalid) {
      // String hashedEmail = DatabaseOperation.getHash(
      //   input: _emailController.text,
      // );

      // final Response httpResponse = await API.makeRequest(
      //   endpoint: '',
      //   body: {
      //     'id': hashedEmail,
      //   },
      // );
    } else {
      setState(() {
        _emailErrorText = 'Please type your valid email.';
      });

      _blockInput = false;
    }
  }

  void _storeAccessNumber({
    required String id,
    required String responseBody,
  }) {
    setState(() {
      _emailErrorText = null;
    });

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
          label: TranslationKey.emailLabel.name.tr(),
          controller: _emailController,
          focusNode: _emailFocusNode,
          errorText: _emailErrorText,
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
