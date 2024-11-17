import 'dart:io';

import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/screen_size_pod.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img_lib;

final _ref = ProviderContainer();

late double screenWidth, screenHeight;

void _updateScreenSize() {
  screenWidth = _ref.read(screenSize).width;
  screenHeight = _ref.read(screenSize).height;
}

class CameraUtility {
  static double calculateCamFrameSize() {
    _updateScreenSize();

    var camFrameSize = (screenWidth < screenHeight) //
        ? screenWidth
        : screenHeight / 2;
    camFrameSize -= PaddingSize.verySmall;

    return camFrameSize;
  }

  static Future<Face?> detectFace({
    required CameraImage camImage,
    required int sensorOrientation,
    required FaceDetector faceDetector,
  }) async {
    final InputImage preppedImage = InputImage.fromBytes(
      bytes: _extractBytes(camImage),
      metadata: _generateMetadata(
        camImage: camImage,
        sensorOrientation: sensorOrientation,
      ),
    );
    final List<Face> detectedFaces = await faceDetector.processImage(
      preppedImage,
    );

    return _findCenteredFace(
      faces: detectedFaces,
      camImageSize: Size(
        camImage.width.toDouble(),
        camImage.height.toDouble(),
      ),
    );
  }

  static Uint8List _extractBytes(CameraImage camImage) {
    final WriteBuffer bytesInBuffer = WriteBuffer();

    for (final plane in camImage.planes) {
      bytesInBuffer.putUint8List(plane.bytes);
    }

    return bytesInBuffer.done().buffer.asUint8List();
  }

  static InputImageMetadata _generateMetadata({
    required CameraImage camImage,
    required int sensorOrientation,
  }) {
    final size = Size(camImage.width.toDouble(), camImage.height.toDouble());

    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation) ??
        InputImageRotation.rotation0deg;

    final format = InputImageFormatValue.fromRawValue(camImage.format.raw) ??
        InputImageFormat.nv21;

    return InputImageMetadata(
      size: size,
      rotation: rotation,
      format: format,
      bytesPerRow: camImage.planes[0].bytesPerRow,
    );
  }

  static Face? _findCenteredFace({
    required List<Face> faces,
    required Size camImageSize,
  }) {
    final screenWidth = _ref.read(screenSize).width;
    final screenHeight = _ref.read(screenSize).height;

    final screenCenter = Offset(screenWidth / 2, screenHeight / 2);

    for (final Face face in faces) {
      final Rect facialBoundingBox = _normalizeBoundingBox(
        rect: face.boundingBox,
        camImageSize: camImageSize,
      );

      final Offset faceCenter = Offset(
        facialBoundingBox.left + facialBoundingBox.width / 2,
        facialBoundingBox.top + facialBoundingBox.height / 2,
      );

      final bool isFaceCentered = _validatePose(
        screenCenter: screenCenter,
        faceCenter: faceCenter,
        face: face,
      );

      if (isFaceCentered) {
        return Face(
          trackingId: face.trackingId,
          boundingBox: facialBoundingBox,
          landmarks: face.landmarks,
          contours: face.contours,
          smilingProbability: face.smilingProbability,
        );
      }
    }

    return null;
  }

  static Rect _normalizeBoundingBox({
    required Rect rect,
    required Size camImageSize,
  }) {
    final double scaleX = screenWidth / camImageSize.height;
    final double scaleY = screenHeight / camImageSize.width;

    final double scale = scaleX > scaleY ? scaleX : scaleY;
    final Offset offset = Offset(
      (screenWidth - camImageSize.height * scale) / 2,
      (screenHeight - camImageSize.width * scale) / 2,
    );

    return Rect.fromLTWH(
      rect.left * scale + offset.dx,
      rect.top * scale + offset.dy,
      rect.width * scale,
      rect.height * scale,
    );
  }

  static bool _validatePose({
    required Offset screenCenter,
    required Offset faceCenter,
    required Face face,
  }) {
    const double maxCoordinateDeviation = 40.0;
    const double maxPoseInaccuracy = 20.0;

    final double headTilt = face.headEulerAngleX ?? double.infinity;
    final double headTurn = face.headEulerAngleY ?? double.infinity;
    final double headRotation = face.headEulerAngleZ ?? double.infinity;

    final double dxDifference = (screenCenter.dx - faceCenter.dx).abs();
    final double dyDifference = (screenCenter.dy - faceCenter.dy).abs();

    return dxDifference <= maxCoordinateDeviation &&
        dyDifference <= maxCoordinateDeviation &&
        headTilt.abs() <= maxPoseInaccuracy &&
        headTurn.abs() <= maxPoseInaccuracy &&
        headRotation.abs() <= maxPoseInaccuracy;
  }

  static Future<img_lib.Image?> formatPhoto({
    required String photoPath,
  }) async {
    final originalPhoto =
        img_lib.decodeImage(await File(photoPath).readAsBytes());

    if (originalPhoto != null) {
      final stretchedPhoto = img_lib.copyResize(
        originalPhoto,
        width: screenWidth.toInt(),
        height: screenHeight.toInt(),
      );

      final int targetSize = calculateCamFrameSize().toInt();
      final int offsetX = (stretchedPhoto.width - targetSize) ~/ 2;
      final int offsetY = (stretchedPhoto.height - targetSize) ~/ 2;

      final croppedPhoto = img_lib.copyCrop(
        stretchedPhoto,
        x: offsetX,
        y: offsetY,
        width: targetSize,
        height: targetSize,
      );

      img_lib.Image flippedPhoto = img_lib.flip(
        croppedPhoto,
        direction: img_lib.FlipDirection.horizontal,
      );

      return flippedPhoto;
    } else {
      return originalPhoto;
    }
  }

  static Widget displayPhoto(img_lib.Image? photo) {
    if (photo == null) {
      return const Icon(Icons.no_photography_outlined);
    } else {
      return ClipOval(
        child: Image.memory(Uint8List.fromList(img_lib.encodePng(photo))),
      );
    }
  }
}
