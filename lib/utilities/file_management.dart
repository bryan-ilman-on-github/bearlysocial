class FileManagement {
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
      return '$filePath$suffix'; // If there's no extension, just append the suffix
    }
  }
}
