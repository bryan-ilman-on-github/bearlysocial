import 'dart:async';
import 'dart:math';

import 'package:bearlysocial/components/buttons/splash_btn.dart';
import 'package:bearlysocial/components/texts/animated_elliptical_txt.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/utils/fs_util.dart';
import 'package:bearlysocial/utils/selfie_capture_utils.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img_lib;

part 'package:bearlysocial/components/lines/camera_frame.dart';

class SelfieScreen extends ConsumerStatefulWidget {
  final CameraDescription frontCamera;
  final Function({required img_lib.Image? profilePic}) onPictureSuccess;

  const SelfieScreen({
    super.key,
    required this.frontCamera,
    required this.onPictureSuccess,
  });

  @override
  ConsumerState<SelfieScreen> createState() => _SelfieScreen();
}

class _SelfieScreen extends ConsumerState<SelfieScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late CameraController _camController;

  late Future<void> _camInit;

  double? _yAxisValue;
  double? _xAxisValue;

  Face? _prevDetectedFace;
  bool _detecting = false;

  Timer? _focusTimer;
  bool _settingFocus = false;

  XFile? _selfie;

  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableClassification: true,
      enableTracking: true,
    ),
  );

  void _calculateCameraFrameCancelButtonPosition() {
    final screenSize = MediaQuery.of(context).size;
    final frameSize = SelfieCaptureOperation.calculateCameraFrameSize(
      screenSize: screenSize,
    );

    final frameRadius = frameSize / 2;
    const angleSize = (45 / 180) * pi; // in radian

    final top = (screenSize.height / 2) - (sin(angleSize) * frameRadius);
    final right = (screenSize.width / 2) - (cos(angleSize) * frameRadius);

    setState(() {
      _yAxisValue = top - 24.0; // this number is arbitrary
      _xAxisValue = right - 16.0; // this number is arbitrary
    });
  }

  void _insertCamFlash() {
    if (!mounted) return;

    OverlayEntry camFlash = OverlayEntry(
      builder: (ctx) => Positioned.fill(
        child: Container(
          color: Colors.white,
        ),
      ),
    );

    Overlay.of(context).insert(camFlash);

    Future.delayed(
      const Duration(
        milliseconds: AnimationDuration.quick,
      ),
      () => camFlash.remove(),
    );
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: AnimationDuration.slow,
      ),
      vsync: this,
    )..repeat(reverse: true);

    _camController = CameraController(
      widget.frontCamera,
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    _camInit = _camController.initialize().then((_) {
      if (!mounted) return;

      final Size screenSize = MediaQuery.of(context).size;

      _camController.startImageStream((CameraImage img) async {
        if (!_detecting) {
          _detecting = true;

          final Face? nowDetectedFace = await SelfieCaptureOperation.detectFace(
            screenSize: screenSize,
            image: img,
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
            _insertCamFlash();

            await _camController.stopImageStream();

            final String? initialFilePath = _selfie?.path;

            if (initialFilePath == null) {
              return;
            }

            final String renamedFilePath = FileManagement.addSuffixToFilePath(
              filePath: initialFilePath,
              suffix: '-compressed',
            );

            await FlutterImageCompress.compressAndGetFile(
              initialFilePath,
              renamedFilePath,
              quality: 16,
            );

            final img_lib.Image? profilePic =
                await SelfieCaptureOperation.buildProfilePic(
              imagePath: renamedFilePath,
              screenSize: screenSize,
            );

            widget.onPictureSuccess(profilePic: profilePic);
          }

          setState(() {
            _prevDetectedFace = nowDetectedFace;
          });

          _detecting = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _faceDetector.close();
    _animationController.dispose();
    _camController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _calculateCameraFrameCancelButtonPosition();

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
                            controller: _animationController,
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
                            controller: _animationController,
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
              Positioned(
                top: _yAxisValue,
                right: _xAxisValue,
                child: UnconstrainedBox(
                  child: SplashButton(
                    horizontalPadding: PaddingSize.verySmall,
                    verticalPadding: PaddingSize.verySmall,
                    buttonColor: Colors.white,
                    borderRadius: BorderRadius.circular(
                      CurvatureSize.infinity,
                    ),
                    callbackFunction: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColor.heavyGray,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
