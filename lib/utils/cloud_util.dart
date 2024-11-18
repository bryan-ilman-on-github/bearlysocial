import 'dart:convert';
import 'dart:io';

import 'package:bearlysocial/aliases/URI.dart';
import 'package:bearlysocial/constants/db_key.dart';
import 'package:bearlysocial/constants/design_tokens.dart';
import 'package:bearlysocial/providers/statuses_pod.dart';
import 'package:bearlysocial/utils/local_db_util.dart';
import 'package:bearlysocial/views/sheets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:http_status_code/http_status_code.dart';

final _ref = ProviderContainer();
typedef Anchor = BuildContext;

/// This class provides utility functions for handling cloud-related operations.
class CloudUtility {
  /// Sends an HTTP request with an optional JSON body and image upload.
  ///
  /// The `endpoint` parameter specifies the URL to which the request is sent.
  ///
  /// The `method` parameter allows the developer to specify the HTTP method (GET, POST, PUT, DELETE).
  ///
  /// The `onSuccess` callback is invoked if the request is successful (status code 200).
  ///
  /// The `onBadRequest` callback is invoked if the request returns a bad request status (status code 400).
  ///
  /// The optional `body` parameter contains the data to be included in the request's body (JSON encoded if provided).
  ///
  /// The optional `image` parameter, if provided, will be included as a file attachment (only for POST/PUT).
  ///
  /// This function assumes a token is fetched from the local database and placed in the HTTP headers.
  /// If the request is unauthorized, the app will log the user out.
  /// For other server errors, a full-screen modal will be displayed to the user.
  ///
  /// This function is asynchronous.
  static Future<void> sendRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    File? image,
    required Anchor context,
    required Function onSuccess,
    required Function onBadRequest,
  }) async {
    var url = URI.parse(endpoint);

    String token =
        LocalDatabaseUtility.retrieveTransaction(key: DatabaseKey.token.name);

    http.BaseRequest request;

    if (method == 'POST' || method == 'PUT') {
      request = http.MultipartRequest(method, url);

      if (body != null) {
        (request as http.MultipartRequest).fields['json'] = jsonEncode(body);
      }
      if (image != null) {
        (request as http.MultipartRequest).files.add(
              http.MultipartFile.fromBytes(
                'image',
                await image.readAsBytes(),
                contentType: MediaType('image', 'jpeg'),
              ),
            );
      }
    } else {
      request = http.Request(method, url);
      request.headers['Content-Type'] = 'application/json';

      if (body != null) (request as http.Request).body = jsonEncode(body);
    }

    request.headers['Authorization'] = 'Bearer $token';
    final response = await _parseResponse(await request.send());

    if (response.statusCode == StatusCode.OK) {
      onSuccess(response);
    } else if (response.statusCode == StatusCode.BAD_REQUEST) {
      onBadRequest(response);
    } else if (response.statusCode == StatusCode.UNAUTHORIZED) {
      _ref.read(setAuthStatus)(false);
    } else {
      if (!context.mounted) return;

      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (context) {
          return DismissibleBottomSheet(
            title: "Internal Server Error",
            content: Column(
              children: [
                SvgPicture.asset(
                  'assets/svgs/server_error_icon.svg',
                  width: SideSize.large / 1.6,
                  height: SideSize.large / 1.6,
                  color: Theme.of(context).focusColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(PaddingSize.large),
                  child: Text(
                    'Oops! Something went wrong on our end. Please wait a bit and try again later. Thanks for your patience!',
                    maxLines: 16,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  static Future<dynamic> _parseResponse(http.StreamedResponse response) async {
    final contentType = response.headers['content-type'];

    if (contentType != null && contentType.contains('application/json')) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      return await response.stream.toBytes();
    }
  }
}
