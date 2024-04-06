import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img_lib;

class ProfilePicture extends StatelessWidget {
  final dynamic imageSource;

  const ProfilePicture({
    super.key,
    this.imageSource,
  });

  Widget _getProfilePic() {
    switch (imageSource.runtimeType) {
      case img_lib.Image:
        return ClipOval(
          child: Image.memory(
            Uint8List.fromList(
              img_lib.encodePng(imageSource),
            ),
          ),
        );
      default:
        return const Icon(
          Icons.no_photography_outlined,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SideSize.large,
      height: SideSize.large,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: imageSource == null
            ? Border.all(
                color: Theme.of(context).dividerColor,
              )
            : null,
      ),
      child: Center(
        child: _getProfilePic(),
      ),
    );
  }
}
