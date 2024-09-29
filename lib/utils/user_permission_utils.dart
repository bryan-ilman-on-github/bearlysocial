import 'package:permission_handler/permission_handler.dart';

/// This class provides utility functions to manage user permissions.
class UserPermissionUtilities {
  /// This getter checks the current camera permission status and requests permission if not already granted.
  ///
  /// This getter is asynchronous and returns a Future that completes with a boolean value
  /// indicating whether the camera permission is granted.
  static Future<bool> get cameraPermission async {
    final PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      return await Permission.camera.request().isGranted;
    }

    return false;
  }
}
