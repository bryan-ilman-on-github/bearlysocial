import 'package:permission_handler/permission_handler.dart';

class UserPermission {
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
