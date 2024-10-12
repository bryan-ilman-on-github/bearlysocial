class DigitalOceanSpacesAPI {
  /// The domain name for DigitalOcean Spaces.
  static const String _domain = 'digitaloceanspaces';

  /// The region where the DigitalOcean Spaces bucket is located.
  static const String _region = 'sfo3';

  /// The name of the bucket in DigitalOcean Spaces.
  static const String _bucketName = 'profile-pics-on-bearlysocial';

  /// The host URL for the DigitalOcean Spaces bucket.
  static const String _host = '$_bucketName.$_region.$_domain.com';

  /// Generates the full URL to retrieve a profile picture stored in the DigitalOcean Spaces bucket.
  ///
  /// The `uid` parameter represents the unique identifier for the user's profile picture.
  /// This function constructs a URL by combining the host URL (which includes the bucket name, region, and domain) with the provided `uid`.
  ///
  /// Returns a complete URL in the format `https://<bucket-name>.<region>.<domain>/<uid>`, pointing to the user's profile picture.
  static String generateURL(String uid) {
    return 'https://$_host/$uid';
  }
}

class DigitalOceanDropletAPI {
  // The base path for DigitalOcean droplet.
  static const String _basePath = 'http://localhost:8080';

  // The specific endpoints for various functions.
  static const String deleteAccount = '$_basePath/delete-account';
  static const String requestOTP = '$_basePath/request-otp';
  static const String validateOTP = '$_basePath/validate-otp';
  static const String updateProfile = '$_basePath/update-profile';
}
