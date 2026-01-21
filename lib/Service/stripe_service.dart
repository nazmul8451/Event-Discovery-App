import 'dart:convert';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

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
    final String url = '${Urls.baseUrl}/api/v1/payment/create-checkout-session';
    
    final Map<String, dynamic> body = {};
    if (ticketId != null && ticketId.isNotEmpty) {
      body['ticketId'] = ticketId;
    } else {
      body['amount'] = amount;
      body['currency'] = currency;
    }

    _debugPrint('createCheckoutSession request: ${jsonEncode(body)}');
    final response = await NetworkCaller.postRequest(url: url, body: body, requireAuth: true);
    _debugPrint('createCheckoutSession response: ${response.statusCode} ${response.body}');

    if (response.isSuccess && response.body != null) {
      final Map<String, dynamic> data = response.body!['data'] is Map ? response.body!['data'] as Map<String, dynamic> : response.body!;
      
      if (data.containsKey('url')) return data['url'] as String;
      if (data.containsKey('sessionId')) return data['sessionId'] as String;
      if (data.containsKey('sessionUrl')) return data['sessionUrl'] as String;
      
      return jsonEncode(response.body);
    }

    throw Exception('createCheckoutSession failed: ${response.statusCode} ${response.errorMessage ?? response.body}');
  }

  /// Calls backend to create a PaymentIntent (or server-side equivalent). Returns client secret, session id or url.
  static Future<String> createPaymentIntent(String amount, String currency, {String? ticketId}) async {
    final String url = '${Urls.baseUrl}/api/v1/payment/create-payment-intent';
    
    final Map<String, dynamic> body = {};
    if (ticketId != null && ticketId.isNotEmpty) {
      body['ticketId'] = ticketId;
    } else {
      body['amount'] = amount;
      body['currency'] = currency;
    }

    _debugPrint('createPaymentIntent request: ${jsonEncode(body)}');
    final response = await NetworkCaller.postRequest(url: url, body: body, requireAuth: true);
    _debugPrint('createPaymentIntent response: ${response.statusCode} ${response.body}');

    if (response.isSuccess && response.body != null) {
      final Map<String, dynamic> data = response.body!['data'] is Map ? response.body!['data'] as Map<String, dynamic> : response.body!;
      
      if (data.containsKey('clientSecret')) return data['clientSecret'] as String;
      if (data.containsKey('sessionId')) return data['sessionId'] as String;
      if (data.containsKey('url')) return data['url'] as String;
      
      return jsonEncode(response.body);
    }

    throw Exception('createPaymentIntent failed: ${response.statusCode} ${response.errorMessage ?? response.body}');
  }

  static void _debugPrint(String msg) {
    try {
      // ignore: avoid_print
      print('StripeService: $msg');
    } catch (_) {}
  }
}
