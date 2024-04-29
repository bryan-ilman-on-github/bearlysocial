import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img_lib;

class API {
  static Future<http.Response> makeRequest({
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

  static Future<String?> imageUpload({
    required img_lib.Image img,
    required String uid,
  }) async {
    const awsAccessKey = 'DO004AT6D3K96TFACPC4';
    const awsSecretKey = '5GYrD9KeS+FDjci7d5w+WDiM0Bi2tqfgoSDw410eNTw';
    const region = 'sfo2';
    const host = 'profile-pics-on-bearlysocial.$region.digitaloceanspaces.com';

    final Uint8List imageBytes = Uint8List.fromList(img_lib.encodeJpg(img));
    const String mimeType = 'image/jpeg';
    final String filename = '$uid.jpg';

    const awsCredentials = AWSCredentials(awsAccessKey, awsSecretKey);
    const signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(awsCredentials),
    );

    final uploadRequest = AWSStreamedHttpRequest.put(
      Uri.https(host, filename),
      body: Stream.fromIterable(
        imageBytes.map(
          (byte) => [byte],
        ),
      ),
      headers: {
        AWSHeaders.host: host,
        AWSHeaders.contentType: mimeType,
        'x-amz-acl': 'private',
        'Content-Length': imageBytes.length.toString(),
      },
    );

    final signedUploadRequest = await signer.sign(
      uploadRequest,
      credentialScope: AWSCredentialScope(
        region: region,
        service: AWSService.s3,
      ),
      serviceConfiguration: S3ServiceConfiguration(),
    );

    print(imageBytes.length.toString());
    final uploadResponse = await signedUploadRequest.send().response;

    if (uploadResponse.statusCode == 200) {
      return 'https://$host/$filename';
    } else {
      return null;
    }
  }
}
