import 'dart:io';

import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/screen_size_pod.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img_lib;
import 'package:isar/isar.dart';

final ref = ProviderContainer();

late double screenWidth, screenHeight;

void _updateScreenSize() {
  screenWidth = ref.read(screenSize).width;
  screenHeight = ref.read(screenSize).height;
}

class SelfieUtility {
  static double calculateCamFrameSize() {
    _updateScreenSize();

    var camFrameSize = (screenWidth < screenHeight) //
        ? screenWidth
        : screenHeight / 2;
    camFrameSize -= PaddingSize.verySmall;

    return camFrameSize;
  }

  static Future<Face?> detectFace({
    required int sensorOrientation,
    required CameraImage image,
    required FaceDetector faceDetector,
  }) async {
    final InputImage preppedImage = InputImage.fromBytes(
      bytes: _extractBytes(image),
      metadata: _buildImageMetadata(
        image: image,
        sensorOrientation: sensorOrientation,
      ),
    );
    final List<Face> detectedFaces = await faceDetector.processImage(
      preppedImage,
    );

    return findCenteredFace(
      faces: detectedFaces,
      image: image,
    );
  }

  static Uint8List _extractBytes(CameraImage image) {
    final WriteBuffer bytesInBuffer = WriteBuffer();

    for (final plane in image.planes) {
      bytesInBuffer.putUint8List(plane.bytes);
    }

    return bytesInBuffer.done().buffer.asUint8List();
  }

  static InputImageMetadata _buildImageMetadata({
    required CameraImage image,
    required int sensorOrientation,
  }) {
    final size = Size(image.width.toDouble(), image.height.toDouble());

    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation) ??
        InputImageRotation.rotation0deg;

    final format = InputImageFormatValue.fromRawValue(image.format.raw) ??
        InputImageFormat.nv21;

    return InputImageMetadata(
      size: size,
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );
  }

  static Face? findCenteredFace({
    required List<Face> faces,
    required CameraImage image,
  }) {
    final screenWidth = ref.read(screenSize).width;
    final screenHeight = ref.read(screenSize).height;

    final screenCenter = Offset(screenWidth / 2, screenHeight / 2);

    for (final Face face in faces) {
      final Rect facialBoundingBox = normalizeBoundingBox(
        rect: face.boundingBox,
        imageSize: Size(
          image.width.toDouble(),
          image.height.toDouble(),
        ),
      );

      final Offset faceCenter = Offset(
        facialBoundingBox.left + facialBoundingBox.width / 2,
        facialBoundingBox.top + facialBoundingBox.height / 2,
      );

      final bool faceIsCentered = validateFacePosition(
        screenCenter: screenCenter,
        faceCenter: faceCenter,
        face: face,
      );

      if (faceIsCentered) {
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

  static Rect normalizeBoundingBox({
    required Rect rect,
    required Size imageSize,
  }) {
    final double scaleX = screenWidth / imageSize.height;
    final double scaleY = screenHeight / imageSize.width;

    final double scale = scaleX > scaleY ? scaleX : scaleY;
    final Offset offset = Offset(
      (screenWidth - imageSize.height * scale) / 2,
      (screenHeight - imageSize.width * scale) / 2,
    );

    return Rect.fromLTWH(
      rect.left * scale + offset.dx,
      rect.top * scale + offset.dy,
      rect.width * scale,
      rect.height * scale,
    );
  }

  static bool validateFacePosition({
    required Offset screenCenter,
    required Offset faceCenter,
    required Face face,
  }) {
    const double coordinateDeviation = 40.0;
    const double poseInaccuracy = 20.0;

    final double headTilt = face.headEulerAngleX ?? double.infinity;
    final double headTurn = face.headEulerAngleY ?? double.infinity;
    final double headRotation = face.headEulerAngleZ ?? double.infinity;

    final double dxDifference = (screenCenter.dx - faceCenter.dx).abs();
    final double dyDifference = (screenCenter.dy - faceCenter.dy).abs();

    return dxDifference <= coordinateDeviation &&
        dyDifference <= coordinateDeviation &&
        headTilt.abs() <= poseInaccuracy &&
        headTurn.abs() <= poseInaccuracy &&
        headRotation.abs() <= poseInaccuracy;
  }

  static Future<img_lib.Image?> buildProfilePic({
    required String imagePath,
  }) async {
    final img_lib.Image? image = img_lib.decodeImage(
      await File(imagePath).readAsBytes(),
    );

    if (image != null) {
      final int newWidth = screenWidth.toInt();
      final int newHeight = screenHeight.toInt();
      final img_lib.Image stretchedImage = img_lib.copyResize(
        image,
        width: newWidth,
        height: newHeight,
      );

      final int size = calculateCamFrameSize().toInt();
      final int offsetX = (stretchedImage.width - size) ~/ 2;
      final int offsetY = (stretchedImage.height - size) ~/ 2;

      final img_lib.Image croppedImage = img_lib.copyCrop(
        stretchedImage,
        x: offsetX,
        y: offsetY,
        width: size,
        height: size,
      );

      img_lib.Image flippedImage = img_lib.flip(
        croppedImage,
        direction: img_lib.FlipDirection.horizontal,
      );

      return flippedImage;
    } else {
      return image;
    }
  }

  static Widget buildCircularImage(img_lib.Image? img) {
    if (img == null) {
      return const Icon(
        Icons.no_photography_outlined,
      );
    } else {
      return ClipOval(
        child: Image.memory(Uint8List.fromList(
          img_lib.encodePng(img),
        )),
      );
    }
  }
}
