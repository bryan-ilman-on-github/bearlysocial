// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:math';

import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/screen_size_pod.dart';
import 'package:bearlysocial/utils/cam_util.dart';
import 'package:bearlysocial/utils/fs_util.dart';
import 'package:bearlysocial/views/buttons/cancel_btn.dart';
import 'package:bearlysocial/views/texts/animated_elliptical_txt.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img_lib;

part 'package:bearlysocial/views/lines/camera_frame.dart';

typedef fs_util = FileSystemUtility;

class SelfieScreen extends ConsumerStatefulWidget {
  final CameraDescription frontCamera;
  final Function(img_lib.Image?) onCapture;

  const SelfieScreen({
    super.key,
    required this.frontCamera,
    required this.onCapture,
  });

  @override
  ConsumerState<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends ConsumerState<SelfieScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _looper;

  late CameraController _camController;
  late Future<void> _camInit;

  _Position? _cancelButtonPosition;

  Face? _prevFace;
  bool _isDetecting = false;

  Timer? _autoFocusTimer;
  bool _isAdjustingFocus = false;

  XFile? _capturedImage;

  final _faceDetector = GoogleMl.vision.faceDetector(
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

    final camFrameSize = CameraUtility.calculateCamFrameSize();
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

      _camController.startImageStream((camImage) async {
        if (!_isDetecting) {
          _isDetecting = true; // TODO: check if smooth.

          final Face? currFace = await CameraUtility.detectFace(
            camImage: camImage,
            sensorOrientation: widget.frontCamera.sensorOrientation,
            faceDetector: _faceDetector,
          );

          final bool sameFace = _prevFace?.trackingId == currFace?.trackingId;
          final double? smilingProbability = currFace?.smilingProbability;

          final bool highSmilingProbability =
              smilingProbability != null && smilingProbability >= 0.98;

          if (sameFace && highSmilingProbability) {
            Future.delayed(
              const Duration(milliseconds: AnimationDuration.slow),
              () => Navigator.pop(context),
            );

            _capturedImage = await _camController.takePicture();
            _camFlash();

            await _camController.stopImageStream();

            final String? originalFilePath = _capturedImage?.path;
            if (originalFilePath == null) return;

            final String renamedFilePath = fs_util.addSuffixToFilePath(
              filePath: originalFilePath,
              suffix: '-compressed',
            );

            await FlutterImageCompress.compressAndGetFile(
              originalFilePath,
              renamedFilePath,
              quality: 16,
            );

            final formattedPhoto = await CameraUtility.formatPhoto(
              photoPath: renamedFilePath,
            );
            widget.onCapture(formattedPhoto);
          }

          setState(() => _prevFace = currFace);
          _isDetecting = false;
        }
      });
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateCancelButtonPosition());
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
                    child: _prevFace == null
                        ? AnimatedEllipticalText(
                            looper: _looper,
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
                      color: _isAdjustingFocus
                          ? AppColor.lightYellow
                          : Colors.white,
                      gapSize: _prevFace == null
                          ? MarginSize.veryLarge
                          : MarginSize.verySmall / 10,
                    ),
                  ),
                  Expanded(
                    child: _isAdjustingFocus
                        ? AnimatedEllipticalText(
                            looper: _looper,
                            textStyle: whiteTextStyle,
                            leadingText: 'Adjusting focus',
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              GestureDetector(
                onTapUp: (details) {
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
                  setState(() => _isAdjustingFocus = true);

                  _autoFocusTimer?.cancel();
                  _autoFocusTimer = Timer(
                    const Duration(
                      milliseconds: AnimationDuration.slow * 2,
                    ),
                    () => setState(() => _isAdjustingFocus = false),
                  );
                },
              ),
              if (_cancelButtonPosition != null)
                CancelButton(
                  top: _cancelButtonPosition?.top,
                  right: _cancelButtonPosition?.right,
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
