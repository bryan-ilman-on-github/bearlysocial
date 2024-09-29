class DigitalOceanSpacesDetails {
  /// The access key for DigitalOcean Spaces.
  static const String accessKey = 'DO004AT6D3K96TFACPC4';

  /// The secret key for DigitalOcean Spaces.
  static const String secretKey = '5GYrD9KeS+FDjci7d5w+WDiM0Bi2tqfgoSDw410eNTw';

  /// The domain name for DigitalOcean Spaces.
  static const String domain = 'digitaloceanspaces';

  /// The region where the DigitalOcean Spaces bucket is located.
  static const String region = 'sfo3';

  /// The name of the bucket in DigitalOcean Spaces.
  static const String bucketName = 'profile-pics-on-bearlysocial';

  /// The host URL for the DigitalOcean Spaces bucket.
  static const String host = '$bucketName.$region.$domain.com';
}

class DigitalOceanFunctionsAPI {
  // base path for DigitalOcean Functions
  static const String basePath = 'http://localhost:8080';
  // 'https://faas-sfo3-7872a1dd.doserverless.co/api/v1/web/fn-d7d4d6e0-9a77-4c55-9404-ed80fa8b49d6/default';

  // specific endpoints for various functions
  static const String deleteAccount = '$basePath/delete-account';
  static const String requestOTP = '$basePath/request-otp';
  static const String validateOTP = '$basePath/validate-otp';
}
