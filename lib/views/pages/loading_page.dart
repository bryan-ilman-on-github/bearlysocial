import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: SideSize.small,
            height: SideSize.small,
            child: CircularProgressIndicator(
              strokeWidth: ThicknessSize.veryLarge,
              color: Theme.of(context).focusColor,
            ),
          ),
        ),
      ),
    );
  }
}
