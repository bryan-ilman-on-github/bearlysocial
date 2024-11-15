import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget nextScreen;

  const SplashScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  Widget build(context) {
    return FutureBuilder(
      future: precacheImage(
        const AssetImage('assets/pngs/bearlysocial_icon.png'),
        context,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedSplashScreen(
            splash: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, -32),
                  child: Container(
                    width: SideSize.medium,
                    height: SideSize.medium,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/pngs/bearlysocial_icon.png'),
                      ),
                      boxShadow: [Shadow.medium],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 28),
                  child: Text(
                    'BearlySocial',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: TextSize.veryLarge / 2,
                        ),
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            duration: 256,
            nextScreen: nextScreen,
          );
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const SizedBox(),
          );
        }
      },
    );
  }
}
