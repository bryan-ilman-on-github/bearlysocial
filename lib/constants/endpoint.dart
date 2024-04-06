/// A class that defines the endpoints for the APIs.
class Endpoint {
  /// The endpoint for signing up a new user.
  static const String signUp = '$_apiBasePath/sign-up';

  /// The endpoint for signing in an existing user.
  static const String signIn = '$_apiBasePath/sign-in';

  /// The endpoint for validating a user's token.
  static const String validateToken = '$_apiBasePath/validate-token';
}

/// The scheme for the URL
const String _scheme = 'https';

/// The subdomain for the URL
const String _subDomain = 'zd0d10d8p2.execute-api.us-east-1';

/// The domain for the URL
const String _domain = 'amazonaws';

/// The top-level domain for the URL
const String _topLevelDomain = 'com';

/// The API path for the URL
const String _apiPath = '';

/// The base path for all APIs
const String _apiBasePath =
    '$_scheme://$_subDomain.$_domain.$_topLevelDomain/$_apiPath';
