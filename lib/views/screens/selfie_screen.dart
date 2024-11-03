import 'dart:async';
import 'dart:math';

import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/screen_size_pod.dart';
import 'package:bearlysocial/utils/fs_util.dart';
import 'package:bearlysocial/utils/selfie_util.dart';
import 'package:bearlysocial/views/buttons/cancel_btn.dart';
import 'package:bearlysocial/views/buttons/splash_btn.dart';
import 'package:bearlysocial/views/texts/animated_elliptical_txt.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img_lib;

part 'package:bearlysocial/views/lines/camera_frame.dart';

class SelfieScreen extends ConsumerStatefulWidget {
  final CameraDescription frontCamera;
  final Function(img_lib.Image?) onSuccess;

  const SelfieScreen({
    super.key,
    required this.frontCamera,
    required this.onSuccess,
  });

  @override
  ConsumerState<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends ConsumerState<SelfieScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _looper;

  late CameraController _camController;
  late Future<void> _camInit;

  late _Position _cancelButtonPosition;

  Face? _prevDetectedFace;
  bool _isDetecting = false;

  Timer? _focusTimer;
  bool _settingFocus = false;

  XFile? _selfie;

  final _faceDetector = GoogleML.vision.faceDetector(
    FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableClassification: true,
      enableTracking: true,
    ),
  );

  void _updateCancelButtonPosition() {
    ref.read(setScreenSize)(MediaQuery.of(context).size);

    final screenWidth = ref.read(screenSize).width;
    final screenHeight = ref.read(screenSize).height;

    final camFrameSize = SelfieUtility.calculateCamFrameSize();
    final camFrameRadius = camFrameSize / 2;

    final top = (screenHeight / 2) - (sin(pi / 4) * camFrameRadius) - 24.0;
    final right = (screenWidth / 2) - (cos(pi / 4) * camFrameRadius) - 16.0;

    setState(() {
      _cancelButtonPosition = _Position(top: top, right: right);
    });
  }

  void _camFlash() {
    if (!mounted) return;

    OverlayEntry light = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Container(color: Colors.white),
      ),
    );

    Overlay.of(context).insert(light);

    Future.delayed(
      const Duration(milliseconds: AnimationDuration.quick),
      () => light.remove(),
    );
  }

  @override
  void initState() {
    super.initState();

    _looper = AnimationController(
      duration: const Duration(milliseconds: AnimationDuration.slow),
      vsync: this,
    )..repeat(reverse: true);

    _camController = CameraController(
      widget.frontCamera,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    _camInit = _camController.initialize().then((_) {
      if (!mounted) return;

      _camController.startImageStream((image) async {
        if (!_isDetecting) {
          _isDetecting = true; // TODO: check if smooth.

          final Face? nowDetectedFace = await SelfieUtility.detectFace(
            image: image,
            sensorOrientation: widget.frontCamera.sensorOrientation,
            faceDetector: _faceDetector,
          );

          // Check if the detected face is the same as the previously detected face
          final bool sameFace =
              _prevDetectedFace?.trackingId == nowDetectedFace?.trackingId;

          final double? smilingProbability =
              nowDetectedFace?.smilingProbability;

          // Check if the detected face is smiling with a high probability (98% or more)
          final bool highSmilingProbability =
              smilingProbability != null && smilingProbability >= 0.98;

          if (sameFace && highSmilingProbability) {
            Future.delayed(
              const Duration(milliseconds: AnimationDuration.slow),
              () => Navigator.pop(context),
            );

            _selfie = await _camController.takePicture();
            _camFlash();

            await _camController.stopImageStream();

            final String? initialFilePath = _selfie?.path;

            if (initialFilePath == null) {
              return;
            }

            final String renamedFilePath =
                FileSystemUtility.addSuffixToFilePath(
              filePath: initialFilePath,
              suffix: '-compressed',
            );

            await FlutterImageCompress.compressAndGetFile(
              initialFilePath,
              renamedFilePath,
              quality: 16,
            );

            final img_lib.Image? profilePic =
                await SelfieUtility.buildProfilePic(
              imagePath: renamedFilePath,
            );

            widget.onSuccess(profilePic);
          }

          setState(() {
            _prevDetectedFace = nowDetectedFace;
          });

          _isDetecting = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _faceDetector.close();
    _looper.dispose();
    _camController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateCancelButtonPosition();

    final whiteTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: TextSize.large,
          color: Colors.white,
        );

    return Scaffold(
      body: FutureBuilder<void>(
        future: _camInit,
        builder: (context, snapshot) {
          return Stack(
            children: <Widget>[
              if (snapshot.connectionState == ConnectionState.done)
                Positioned.fill(
                  child: CameraPreview(_camController),
                ),
              Column(
                children: [
                  Expanded(
                    child: _prevDetectedFace == null
                        ? AnimatedEllipticalText(
                            controller: _looper,
                            textStyle: whiteTextStyle,
                            leadingText: 'Scanning facial features',
                          )
                        : Center(
                            child: Text(
                              'Smile to take a photo.',
                              style: whiteTextStyle,
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _CameraFrame(
                      color:
                          _settingFocus ? AppColor.lightYellow : Colors.white,
                      gapSize: _prevDetectedFace == null
                          ? MarginSize.veryLarge
                          : MarginSize.verySmall / 10,
                    ),
                  ),
                  Expanded(
                    child: _settingFocus
                        ? AnimatedEllipticalText(
                            controller: _looper,
                            textStyle: whiteTextStyle,
                            leadingText: 'Adjusting focus',
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              GestureDetector(
                onTapUp: (TapUpDetails details) {
                  final RenderBox renderBox =
                      context.findRenderObject() as RenderBox;

                  final Offset localPoint = renderBox.globalToLocal(
                    details.globalPosition,
                  );
                  final Offset relativePoint = Offset(
                    localPoint.dx / renderBox.size.width,
                    localPoint.dy / renderBox.size.height,
                  );

                  _camController.setFocusPoint(relativePoint);
                  setState(() => _settingFocus = true);

                  _focusTimer?.cancel();
                  _focusTimer = Timer(
                    const Duration(
                      milliseconds: AnimationDuration.slow * 2,
                    ),
                    () => setState(() => _settingFocus = false),
                  );
                },
              ),
              CancelButton(
                top: _cancelButtonPosition.top,
                right: _cancelButtonPosition.right,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Position {
  final double top;
  final double right;

  _Position({required this.top, required this.right});
}
