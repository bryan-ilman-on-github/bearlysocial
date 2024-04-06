import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/endpoint.dart';
import 'package:bearlysocial/providers/auth_page_email_address_state.dart';
import 'package:bearlysocial/utilities/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPsection extends ConsumerStatefulWidget {
  const OTPsection({super.key});

  @override
  ConsumerState<OTPsection> createState() => _OTPsectionState();
}

class _OTPsectionState extends ConsumerState<OTPsection> {
  bool _enabled = true;

  final List<String> _otp = ['', '', '', '', '', ''];
  String otpErrorText = '';

  String instruction = '';
  String explanation = '';

  @override
  void initState() {
    super.initState();

    API.makeRequest(
      endpoint: Endpoint.sendOTPviaEmail,
      body: {
        'emailAddress': ref.read(authenticationPageEmailAddress),
      },
    ).then((httpResponse) {
      if (httpResponse.statusCode == 200) {
        instruction = 'Please check your email.';
        explanation = "We've sent a one-time password (OTP) to ${ref.read(
          authenticationPageEmailAddress,
        )}.";
      }

      if (httpResponse.statusCode == 429) {
        instruction = 'Please try again later.';
        explanation = 'Too many requests have been made for ${ref.read(
          authenticationPageEmailAddress,
        )}. Please wait approximately 24 minutes before trying again.';
      }
    });
  }

  void _goBack() {
    ref.read(setAuthenticationPageEmailAddress)(emailAddress: '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          instruction,
          maxLines: 2,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 32.0,
              ),
        ),
        Text(
          explanation,
          maxLines: 4,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: WhiteSpaceSize.medium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _otp.asMap().entries.map((char) {
            final int index = char.key;

            return SizedBox(
              width: SideSize.small * 1.5,
              child: TextField(
                enabled: _enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                onChanged: (value) async {
                  _otp[index] = value;

                  if (value.isNotEmpty && index < _otp.length - 1) {
                    FocusScope.of(context).nextFocus();
                  } else if (value.isNotEmpty) {
                    setState(() {
                      _enabled = false;
                    });

                    API.makeRequest(
                      endpoint: Endpoint.verifyOTP,
                      body: {
                        'emailAddress':
                            ref.read(authenticationPageEmailAddress),
                      },
                    ).then((httpResponse) => null);
                  }
                },
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _enabled ? null : Theme.of(context).highlightColor,
                    ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      CurvatureSize.large,
                    ),
                    borderSide: BorderSide(
                      width: ThicknessSize.small,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      CurvatureSize.large,
                    ),
                    borderSide: BorderSide(
                      width: ThicknessSize.medium,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      CurvatureSize.large,
                    ),
                    borderSide: BorderSide(
                      width: ThicknessSize.small,
                      color: Theme.of(context).highlightColor,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: WhiteSpaceSize.verySmall,
        ),
        Text(
          otpErrorText.isEmpty ? "\n" : otpErrorText,
          maxLines: 4,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: WhiteSpaceSize.veryLarge,
        ),
        Row(
          children: [
            SplashButton(
              verticalPadding: PaddingSize.verySmall,
              callbackFunction: _goBack,
              buttonColor: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                  ),
                  const SizedBox(
                    width: WhiteSpaceSize.verySmall,
                  ),
                  Text(
                    'Go Back',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    width: MarginSize.small,
                  )
                ],
              ),
            ),
            const Spacer(),
          ],
        )
      ],
    );
  }
}
