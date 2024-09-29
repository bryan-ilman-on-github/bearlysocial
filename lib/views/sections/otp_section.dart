import 'dart:convert';

import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/cloud_details.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/auth_details/auth_page_email_addr_state.dart';
import 'package:bearlysocial/providers/auth_details/auth_state.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:bearlysocial/utils/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

class OTPsection extends ConsumerStatefulWidget {
  const OTPsection({super.key});

  @override
  ConsumerState<OTPsection> createState() => _OTPsectionState();
}

class _OTPsectionState extends ConsumerState<OTPsection> {
  bool _enabled = true;

  final List<String> _otp = ['', '', '', '', '', ''];
  String _otpErrorText = '';

  void _validateOTP() async {
    String uid = LocalDatabaseUtilities.getSHA256(
      input: ref.read(authPageEmailAddress),
    ).substring(0, 24);

    final Response httpResponse = await DigitalOceanUtilities.performRequest(
      endpoint: DigitalOceanFunctionsAPI.validateOTP,
      body: {
        'id': uid,
        'otp': _otp.join(),
      },
    );

    if (httpResponse.statusCode == 200) {
      DigitalOceanUtilities.downloadProfilePic(
        uid: uid,
      ).then((base64ProfilePic) {
        if (base64ProfilePic != null) {
          LocalDatabaseUtility.insertTransaction(
            key: DatabaseKey.base_64_profile_pic.name,
            value: base64ProfilePic,
          );
        }
      });

      LocalDB.insertTransactions(
        pairs: Map<String, String>.from(
          jsonDecode(httpResponse.body).map(
            (key, value) => MapEntry<String, String>(
              key,
              value?.toString() ?? '',
            ),
          )..removeWhere(
              (_, value) => value == null || value.isEmpty,
            ),
        ),
      );
      ref.read(enterApp)();

      ref.read(setAuthPageEmailAddress)(
        emailAddress: null,
      );
    } else {
      setState(() {
        _otpErrorText = jsonDecode(httpResponse.body)['message'];
      });
    }

    _enabled = true;
  }

  void _goBack() {
    ref.read(setAuthPageEmailAddress)(emailAddress: null);

    _enabled = true;

    _otpErrorText = '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please check your email.',
          maxLines: 2,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 32.0,
              ),
        ),
        Text(
          "We've sent a one-time password (OTP) to ${ref.watch(authPageEmailAddress)}.",
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
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                textAlign: TextAlign.center,
                onChanged: _enabled
                    ? (value) {
                        _otp[index] = value;

                        if (value.isNotEmpty && index < _otp.length - 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isNotEmpty) {
                          _enabled = false;
                          _validateOTP();
                        }
                      }
                    : null,
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
        _enabled
            ? Text(
                _otpErrorText.isEmpty ? "\n" : _otpErrorText,
                maxLines: 4,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : Container(
                margin: const EdgeInsets.only(left: MarginSize.small),
                width: SideSize.verySmall,
                height: SideSize.verySmall,
                child: CircularProgressIndicator(
                  strokeWidth: ThicknessSize.large,
                  color: Theme.of(context).focusColor,
                ),
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
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
