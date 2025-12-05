import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// I AM THE REAL NETWORK CALLER - MOHOSIN 5001 WAS HERE
class NetworkResponse {
  final String? errorMessage;
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? body;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.body,
    this.errorMessage,
  });
}

class NetworkCaller {
  static const String _unAuthorizeMessage = 'Un-authorized token';

  //!Get Request
  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      // final Map<String, String> headers = {'token': ''};

      // Print my Request
      _logRequest(url, null, null);
      Response response = await get(
        uri,
        headers: {'accept': 'application/json'},
      );

      //? print my Response
      _logResponse(url, response);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: decodedJson,
        );
      } else if (response.statusCode == 401) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: _unAuthorizeMessage,
        );
      } else {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decodedJson['message'] ?? _unAuthorizeMessage,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  //! Post Request

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, String>? extraHeaders,
    Map<String, String>? body,
    bool isFromLogin = false,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> finalHeaders = {'Content-Type': 'application/json'};
      if (extraHeaders != null) {
        finalHeaders.addAll(extraHeaders);
      }

      _logRequest(url, body, finalHeaders);

      Response response = await post(
        uri,
        headers: finalHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      _logResponse(url, response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          body: jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: _unAuthorizeMessage,
        );
      } else {
        final decoded = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: decoded['message'] ?? 'Unknown error',
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  //all request and response

  static void _logRequest(
    String url,
    Map<String, String>? body,
    Map<String, String>? headers,
  ) {
    debugPrint(
      '--------------------------request-----------------------------\nURL : $url \nBODY: $body \nHEADERS: $headers\n----------------------------------------------------------',
    );
  }

  static void _logResponse(String url, Response response) {
    debugPrint(
      '=====================Response========================\n'
      'URL: $url \n'
      'BODY:${response.body}\n'
      'STATUS CODE:${response.statusCode}\n'
      '=================================================================',
    );
  }
}
