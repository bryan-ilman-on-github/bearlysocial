/// This class provides utility functions for file system operations.
class FileSystemUtility {
  /// This function adds a suffix to a file path before the file extension.
  ///
  /// The `filePath` parameter is the original file path to which the suffix will be added.
  /// The `suffix` parameter is the string that will be appended to the file name.
  ///
  /// If the file path has an extension, the suffix is added before the extension.
  /// If there is no extension, the suffix is appended directly to the file path.
  static String addSuffixToFilePath({
    required String filePath,
    required String suffix,
  }) {
    int lastDotIndex = filePath.lastIndexOf('.');

    if (lastDotIndex != -1) {
      String extension = filePath.substring(lastDotIndex);
      String fileNameWithoutExtension = filePath.substring(0, lastDotIndex);

      return '$fileNameWithoutExtension$suffix$extension';
    } else {
      return '$filePath$suffix'; // if there's no extension, just append the suffix
    }
  }
}
