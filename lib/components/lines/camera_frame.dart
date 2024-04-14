part of 'package:bearlysocial/views/screens/selfie_screen.dart';

class _CameraFrame extends StatelessWidget {
  final Color color;
  final double gapSize;

  const _CameraFrame({
    required this.color,
    required this.gapSize,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      strokeWidth: ThicknessSize.veryLarge,
      borderType: BorderType.Circle,
      dashPattern: [gapSize],
      borderPadding: const EdgeInsets.all(
        PaddingSize.verySmall,
      ),
      strokeCap: StrokeCap.round,
      color: color,
      child: Container(),
    );
  }
}
