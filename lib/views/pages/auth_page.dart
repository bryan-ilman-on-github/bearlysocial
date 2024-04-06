import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/views/sections/hook_section.dart';
import 'package:bearlysocial/views/sections/otp_section.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _showHook = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingSize.large,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 512.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SideSize.medium,
                  height: SideSize.medium,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/pngs/bearlysocial_icon.png'),
                    ),
                    boxShadow: [
                      Shadow.medium,
                    ],
                  ),
                ),
                const SizedBox(
                  height: WhiteSpaceSize.small,
                ),
                Stack(
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: _showHook ? 1.0 : 0.0,
                      duration: const Duration(
                        milliseconds: AnimationDuration.medium,
                      ),
                      child: const HookSection(),
                    ),
                    AnimatedOpacity(
                      opacity: _showHook ? 0.0 : 1.0,
                      duration: const Duration(
                        milliseconds: AnimationDuration.medium,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: AnimationDuration.medium,
                        ),
                        transform: Matrix4.translationValues(
                          _showHook ? MediaQuery.of(context).size.width / 2 : 0,
                          0,
                          0,
                        ),
                        child: const OTP_Section(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
