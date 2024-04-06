import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTP_Section extends StatefulWidget {
  const OTP_Section({super.key});

  @override
  State<OTP_Section> createState() => _OTP_SectionState();
}

class _OTP_SectionState extends State<OTP_Section> {
  final List<String> _otp = ['', '', '', ''];

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
          "We've sent a one-time password (OTP) to contact@bearly.social.",
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
              width: SideSize.medium,
              child: TextField(
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                ],
                onChanged: (value) {
                  _otp[index] = value;

                  if (value.isNotEmpty && index < _otp.length - 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
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
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: WhiteSpaceSize.veryLarge,
        ),
        Row(
          children: [
            SplashButton(
              horizontalPadding: PaddingSize.small,
              verticalPadding: PaddingSize.verySmall,
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
