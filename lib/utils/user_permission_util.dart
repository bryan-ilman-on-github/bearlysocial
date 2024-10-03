import 'package:permission_handler/permission_handler.dart';

/// This class provides utility functions for handling user permissions.
class UserPermissionUtility {
  /// Requests the camera permission from the user if it hasn't been granted.
  ///
  /// This function returns a `Future<bool>` indicating whether the camera permission is granted.
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
