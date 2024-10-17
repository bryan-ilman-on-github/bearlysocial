import 'dart:convert';

import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/cloud_apis.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/constants/http_methods.dart';
import 'package:bearlysocial/providers/auth_details/auth_page_email_addr_state.dart';
import 'package:bearlysocial/providers/auth_details/auth_state.dart';
import 'package:bearlysocial/utils/cloud_util.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPsection extends ConsumerStatefulWidget {
  const OTPsection({super.key});

  @override
  ConsumerState<OTPsection> createState() => _OTPsectionState();
}

class _OTPsectionState extends ConsumerState<OTPsection> {
  bool _canInvokeCallback = true;

  final List<String> _otp = List.filled(6, '');
  String _otpErrorText = '';

  void _validateOTP() async {
    await CloudUtility.sendRequest(
      endpoint: DigitalOceanDropletAPI.validateOTP,
      method: HTTPmethod.POST.name,
      body: {
        'email_address': ref.read(authPageEmailAddr),
        'otp': _otp.join(),
      },
      onSuccess: (response) async {
        await CloudUtility.sendRequest(
          endpoint: DigitalOceanSpacesAPI.generateURL(response['uid']),
          method: HTTPmethod.GET.name,
          onSuccess: (pic) {
            LocalDatabaseUtility.insertTransaction(
              key: DatabaseKey.base_64_profile_pic.name,
              value: base64Encode(pic),
            );
          },
          onBadRequest: (_) {},
        );

        LocalDatabaseUtility.insertTransactions(
          pairs: Map<String, String>.from(
            response.map(
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

        ref.read(setAuthPageEmailAddr)(
          emailAddr: '',
        );
      },
      onBadRequest: (response) {
        setState(() {
          _otpErrorText = response['message'];
        });
      },
    );

    _canInvokeCallback = true;
  }

  void _goBack() {
    ref.read(setAuthPageEmailAddr)(emailAddr: '');
    _otpErrorText = '';
    _canInvokeCallback = true;
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
          "We've sent a one-time password (OTP) to ${ref.watch(authPageEmailAddr)}.",
          maxLines: 4,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: WhiteSpaceSize.medium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _otp.asMap().entries.map((entry) {
            final int index = entry.key;

            return SizedBox(
              width: SideSize.small * 1.5,
              child: TextField(
                enabled: _canInvokeCallback,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                textAlign: TextAlign.center,
                onChanged: _canInvokeCallback
                    ? (value) {
                        _otp[index] = value;

                        if (value.isNotEmpty && index < _otp.length - 1) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isNotEmpty) {
                          _canInvokeCallback = false;
                          _validateOTP();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus(); // TODO: back.
                        }
                      }
                    : null,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _canInvokeCallback
                          ? null
                          : Theme.of(context).highlightColor,
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
        _canInvokeCallback
            ? Text(
                _otpErrorText.isEmpty ? '\n' : _otpErrorText,
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
