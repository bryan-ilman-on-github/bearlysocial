import 'package:bearlysocial/components/lines/progress_spinner.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/form_fields/profile_pic_loading_state.dart';
import 'package:bearlysocial/providers/form_fields/profile_pic_state.dart';
import 'package:bearlysocial/utils/selfie_capture_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePicture extends ConsumerWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context, var ref) {
    return Container(
      width: SideSize.large,
      height: SideSize.large,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: ref.read(profilePicLoadingState) || ref.read(profilePic) == null
            ? Border.all(
                width: ThicknessSize.medium,
                color: Theme.of(context).dividerColor,
              )
            : null,
      ),
      child: Center(
        child: ref.watch(profilePicLoadingState)
            ? const ProgressSpinner()
            : SelfieCaptureOperation.buildProfilePictureCanvas(
                profilePic: ref.read(profilePic),
              ),
      ),
    );
  }
}
