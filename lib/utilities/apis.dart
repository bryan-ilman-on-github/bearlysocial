import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:bearlysocial/constants/cloud_services_details.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img_lib;

/// A class that handles interactions with AWS Lambda.
class AmazonWebServicesLambdaAPI {
  /// Posts a request to the AWS Lambda endpoint.
  static Future<http.Response> postRequest({
    required String endpoint,
    required Map body,
  }) async {
    var url = Uri.parse(endpoint);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    return response;
  }
}

/// A class that handles interactions with DigitalOcean Spaces.
class DigitalOceanSpacesAPI {
  /// AWS credentials needed to interact with DigitalOcean Spaces.
  static const _awsCredentials = AWSCredentials(
    DigitalOceanSpacesDetails.accessKey,
    DigitalOceanSpacesDetails.secretKey,
  );

  /// AWS signer that uses the provided AWS credentials to sign requests.
  static const _signer = AWSSigV4Signer(
    credentialsProvider: AWSCredentialsProvider(_awsCredentials),
  );

  /// Sends an image to DigitalOcean Spaces.
  static Future<int> sendImage({
    required img_lib.Image image,
    required String uid,
  }) async {
    final Uint8List imageBytes = Uint8List.fromList(img_lib.encodeJpg(image));
    const String mimeType = 'image/jpeg';
    final String filename = '$uid.jpg';

    final uploadRequest = AWSStreamedHttpRequest.put(
      Uri.https(DigitalOceanSpacesDetails.host, filename),
      body: Stream.fromIterable(
        imageBytes.map(
          (byte) => [byte],
        ),
      ),
      headers: {
        AWSHeaders.host: DigitalOceanSpacesDetails.host,
        AWSHeaders.contentType: mimeType,
        'x-amz-acl': 'private',
        'Content-Length': imageBytes.length.toString(),
      },
    );

    final signedUploadRequest = await _signer.sign(
      uploadRequest,
      credentialScope: AWSCredentialScope(
        region: DigitalOceanSpacesDetails.region,
        service: AWSService.s3,
      ),
      serviceConfiguration: S3ServiceConfiguration(),
    );

    final reponse = await signedUploadRequest.send().response;

    return reponse.statusCode;
  }

  /// Gets an image from DigitalOcean Spaces.
  static Future<img_lib.Image?> getImage({
    required String uid,
  }) async {
    final String filename = '$uid.jpg';

    final getRequest = AWSStreamedHttpRequest.get(
      Uri.https(DigitalOceanSpacesDetails.host, filename),
      headers: {
        AWSHeaders.host: DigitalOceanSpacesDetails.host,
      },
    );

    final signedGetRequest = await _signer.sign(
      getRequest,
      credentialScope: AWSCredentialScope(
        region: DigitalOceanSpacesDetails.region,
        service: AWSService.s3,
      ),
      serviceConfiguration: S3ServiceConfiguration(),
    );

    final response = await signedGetRequest.send().response;

    if (response.statusCode == 200) {
      return img_lib.decodeImage(Uint8List.fromList(await response.bodyBytes));
    } else {
      return null;
    }
  }
}
