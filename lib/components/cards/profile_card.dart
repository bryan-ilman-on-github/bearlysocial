import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/texts/decorated_txt.dart';
import 'package:bearlysocial/components/pictures/profile_pic.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/utils/form_util.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final List<String> interests;
  final double rating;
  final String location;

  const ProfileCard({
    super.key,
    required this.name,
    required this.interests,
    required this.rating,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return SplashButton(
      horizontalPadding: PaddingSize.small,
      verticalPadding: PaddingSize.small,
      callbackFunction: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (ctx, p, q) => const SizedBox(),
            transitionsBuilder: (ctx, animation, _, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      buttonColor: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(
        CurvatureSize.large,
      ),
      shadow: Shadow.medium,
      child: Row(
        children: [
          Stack(
            children: <Widget>[
              // const ProfilePicture(
              //   uid: '',
              // ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: DecoratedText(
                  backgroundColor: FormManagement.calculateRatingColor(
                    rating: 4.2,
                  ),
                  text: '4.2',
                ),
              ),
            ],
          ),
          const SizedBox(
            width: PaddingSize.small,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: WhiteSpaceSize.verySmall),
                const Text(
                  'Football, Travel, Artificial Intelligence',
                  maxLines: 4,
                ),
                const SizedBox(height: WhiteSpaceSize.small),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: AppColor.heavyRed,
                    ),
                    const SizedBox(
                      width: WhiteSpaceSize.verySmall,
                    ),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
