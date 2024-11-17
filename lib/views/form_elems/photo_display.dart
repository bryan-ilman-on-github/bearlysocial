import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/statuses_pod.dart';
import 'package:bearlysocial/providers/imgs_pod.dart';
import 'package:bearlysocial/utils/cam_util.dart';
import 'package:bearlysocial/views/lines/progress_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhotoDisplay extends ConsumerWidget {
  const PhotoDisplay({super.key});

  @override
  Widget build(context, ref) {
    return Container(
      width: SideSize.large,
      height: SideSize.large,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: ref.read(isLoadingPhoto) || ref.read(photo) == null
            ? Border.all(
                width: ThicknessSize.medium,
                color: Theme.of(context).dividerColor,
              )
            : null,
      ),
      child: Center(
        child: ref.watch(isLoadingPhoto)
            ? const ProgressSpinner()
            : CameraUtility.displayPhoto(ref.read(photo)),
      ),
    );
  }
}
