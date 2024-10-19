import 'package:bearlysocial/views/lines/progress_spinner.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/flags_pod.dart';
import 'package:bearlysocial/providers/profile_pic_pod.dart';
import 'package:bearlysocial/utils/selfie_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePictureCanvas extends ConsumerWidget {
  const ProfilePictureCanvas({super.key});

  @override
  Widget build(BuildContext context, var ref) {
    return Container(
      width: SideSize.large,
      height: SideSize.large,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: ref.read(isLoadingProfilePic) || ref.read(profilePic) == null
            ? Border.all(
                width: ThicknessSize.medium,
                color: Theme.of(context).dividerColor,
              )
            : null,
      ),
      child: Center(
        child: ref.watch(isLoadingProfilePic)
            ? const ProgressSpinner()
            : SelfieUtility.buildCircularImage(ref.read(profilePic)),
      ),
    );
  }
}
