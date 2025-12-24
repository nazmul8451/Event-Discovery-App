import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gathering_app/Service/urls.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class StripeService {
  /// High level: try checkout session first, fallback to payment intent.
  static Future<String> createPayment({required String amount, required String currency, String? ticketId}) async {
    try {
      return await createCheckoutSession(amount, currency, ticketId: ticketId);
    } catch (e) {
      try {
        return await createPaymentIntent(amount, currency, ticketId: ticketId);
      } catch (e2) {
        throw Exception('Both createCheckoutSession and createPaymentIntent failed: $e ; $e2');
      }
    }
  }

  /// Calls backend to create a Stripe Checkout session. Returns URL or session id.
  static Future<String> createCheckoutSession(String amount, String currency, {String? ticketId}) async {
    final uri = Uri.parse('${Urls.baseUrl}/api/v1/payment/create-checkout-session');
    final headers = await _buildAuthHeaders();

    final Map<String, dynamic> body = {};
    if (ticketId != null && ticketId.isNotEmpty) {
      body['ticketId'] = ticketId;
    } else {
      body['amount'] = amount;
      body['currency'] = currency;
    }

    _debugPrint('createCheckoutSession request: ${jsonEncode(body)}');
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));
    _debugPrint('createCheckoutSession response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic>? data = json['data'] is Map ? json['data'] as Map<String, dynamic> : null;
      if (data != null) {
        if (data.containsKey('url')) return data['url'] as String;
        if (data.containsKey('sessionId')) return data['sessionId'] as String;
        if (data.containsKey('sessionUrl')) return data['sessionUrl'] as String;
      }
      return response.body;
    }

    throw Exception('createCheckoutSession failed: ${response.statusCode} ${response.body}');
  }

  /// Calls backend to create a PaymentIntent (or server-side equivalent). Returns client secret, session id or url.
  static Future<String> createPaymentIntent(String amount, String currency, {String? ticketId}) async {
    final uri = Uri.parse('${Urls.baseUrl}/api/v1/payment/create-payment-intent');
    final headers = await _buildAuthHeaders();

    final Map<String, dynamic> body = {};
    if (ticketId != null && ticketId.isNotEmpty) {
      body['ticketId'] = ticketId;
    } else {
      body['amount'] = amount;
      body['currency'] = currency;
    }

    _debugPrint('createPaymentIntent request: ${jsonEncode(body)}');
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));
    _debugPrint('createPaymentIntent response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic>? data = json['data'] is Map ? json['data'] as Map<String, dynamic> : null;
      if (data != null) {
        if (data.containsKey('clientSecret')) return data['clientSecret'] as String;
        if (data.containsKey('sessionId')) return data['sessionId'] as String;
        if (data.containsKey('url')) return data['url'] as String;
      }
      return response.body;
    }

    throw Exception('createPaymentIntent failed: ${response.statusCode} ${response.body}');
  }

  static Future<Map<String, String>> _buildAuthHeaders() async {
    final storage = const FlutterSecureStorage();
    String? token;
    try {
      token = await storage.read(key: 'access_token');
      token ??= await storage.read(key: 'token');
      token ??= await storage.read(key: 'accessToken');
    } catch (_) {
      token = null;
    }

    try {
      final box = GetStorage();
      token ??= box.read('access_token');
      token ??= box.read('token');
      token ??= box.read('accessToken');
    } catch (_) {}

    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      headers['token'] = token;
    }

    _debugPrint('auth header present=${headers.containsKey('Authorization')}');
    return headers;
  }

  static void _debugPrint(String msg) {
    try {
      // ignore: avoid_print
      print('StripeService: $msg');
    } catch (_) {}
  }
}
