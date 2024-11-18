import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/txts_pod.dart';
import 'package:bearlysocial/views/sections/hero_section.dart';
import 'package:bearlysocial/views/sections/otp_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: PaddingSize.large),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 512.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SideSize.medium,
                      height: SideSize.medium,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image:
                              AssetImage('assets/pngs/bearlysocial_icon.png'),
                        ),
                        boxShadow: [Shadow.medium],
                      ),
                    ),
                    const SizedBox(height: WhiteSpaceSize.small),
                    Stack(
                      children: <Widget>[
                        AnimatedOpacity(
                          opacity: ref.watch(authEmailAddr).isEmpty ? 1.0 : 0.0,
                          duration: const Duration(
                            milliseconds: AnimationDuration.medium,
                          ),
                          child: const HeroSection(),
                        ),
                        AnimatedOpacity(
                          opacity:
                              ref.watch(authEmailAddr).isNotEmpty ? 1.0 : 0.0,
                          duration: const Duration(
                            milliseconds: AnimationDuration.medium,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: AnimationDuration.medium,
                            ),
                            transform: Matrix4.translationValues(
                              ref.watch(authEmailAddr).isNotEmpty
                                  ? 0
                                  : MediaQuery.of(context).size.width / 2,
                              0,
                              0,
                            ),
                            child: const OTPsection(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
