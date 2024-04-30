/// A class that defines the endpoints for the APIs.
/// These endpoints are used to interact with the AWS Lambda functions.
class AmazonWebServicesLambdaEndpoints {
  /// The domain name for AWS Lambda, typically 'amazonaws'.
  static const String _domain = 'amazonaws';

  /// The subdomain for AWS Lambda, which includes the API gateway and region.
  static const String _subDomain = 'zd0d10d8p2.execute-api.us-east-1';

  // The base path for all AWS Lambda APIs
  static const String _apiBasePath =
      '${UniformResourceLocatorDetails.scheme}://$_subDomain.$_domain.${UniformResourceLocatorDetails.topLevelDomain}/';

  /// This endpoint is for signing up a new user.
  static const String signUp = '$_apiBasePath/sign-up';

  /// This endpoint is for signing in an existing user.
  static const String signIn = '$_apiBasePath/sign-in';

  /// This endpoint is for validating a user's token.
  static const String validateToken = '$_apiBasePath/validate-token';

  /// This endpoint is for sending an OTP via email.
  static const String sendOTPviaEmail = '$_apiBasePath/send-otp-via-email';

  /// This endpoint is for validating an OTP.
  static const String validateOTP = '$_apiBasePath/validate-otp';

  /// This endpoint is for deleting account.
  static const String deleteAccount = '$_apiBasePath/delete-account';
}

/// A class that contains the details for DigitalOcean Spaces.
class DigitalOceanSpacesDetails {
  /// The access key for DigitalOcean Spaces.
  static const String accessKey = 'DO004AT6D3K96TFACPC4';

  /// The secret key for DigitalOcean Spaces.
  static const String secretKey = '5GYrD9KeS+FDjci7d5w+WDiM0Bi2tqfgoSDw410eNTw';

  /// The domain name for DigitalOcean Spaces.
  static const String domain = 'digitaloceanspaces';

  /// The region where the DigitalOcean Spaces bucket is located.
  static const String region = 'sfo2';

  /// The name of the bucket in DigitalOcean Spaces.
  static const String bucketName = 'profile-pics-on-bearlysocial';

  /// The host URL for the DigitalOcean Spaces bucket.
  static const String host =
      '$bucketName.$region.$domain.${UniformResourceLocatorDetails.topLevelDomain}';
}

/// A class that contains the common URL details.
class UniformResourceLocatorDetails {
  /// The scheme of the URL, typically 'https'.
  static const String scheme = 'https';

  /// The top-level domain of the URL, typically 'com'.
  static const String topLevelDomain = 'com';
}
