import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';

class LiveStreamController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _liveStreamData;
  Map<String, dynamic>? get liveStreamData => _liveStreamData;

  Map<String, dynamic>? _agoraTokenData;
  Map<String, dynamic>? get agoraTokenData => _agoraTokenData;

  Future<void> getAgoraToken(String streamId) async {
    print("🎙️ Fetching Agora token for streamId: $streamId");
    _isLoading = true;
    _errorMessage = null;
    _agoraTokenData = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getAgoraTokenUrl(streamId),
        requireAuth: true,
      );

      print("🎙️ Agora Token Response Status: ${response.statusCode}");
      print("🎙️ Agora Token Response Body: ${response.body}");

      if (response.isSuccess && response.body != null) {
        final Map<String, dynamic> body = response.body!;
        if (body['success'] == true && body['data'] != null) {
          _agoraTokenData = body['data'];
          print("✅ Agora token data loaded successfully");
          print("📊 Token: ${_agoraTokenData?['token']}");
          print("📊 Channel Name: ${_agoraTokenData?['channelName']}");
          print("📊 UID: ${_agoraTokenData?['uid']}");
          print("📊 Role: ${_agoraTokenData?['role']}");
          print("📊 Expire Time: ${_agoraTokenData?['expireTime']}");
          print("📊 Streaming Mode: ${_agoraTokenData?['streamingMode']}");
        } else {
          _errorMessage = body['message'] ?? 'Failed to get Agora token';
          print("❌ Agora token API returned error: $_errorMessage");
        }
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to get Agora token';
        print("❌ Agora token API failed: $_errorMessage");
      }
    } catch (e) {
      _errorMessage = 'Exception: $e';
      print("⚠️ Agora token Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLiveStreamByEventId(String eventId) async {
    print("🎥 Fetching live stream for eventId: $eventId");
    _isLoading = true;
    _errorMessage = null;
    _liveStreamData = null;
    notifyListeners();

    try {
      final response = await NetworkCaller.getRequest(
        url: Urls.getLiveStreamByEventID(eventId),
        requireAuth: true,
      );

      print("🎥 Live Stream Response Status: ${response.statusCode}");
      print("🎥 Live Stream Response Body: ${response.body}");

      if (response.isSuccess && response.body != null) {
        final Map<String, dynamic> body = response.body!;
        if (body['success'] == true && body['data'] != null) {
          _liveStreamData = body['data'];
          print("✅ Live stream data loaded successfully");
        } else {
          _errorMessage = body['message'] ?? 'Failed to load live stream';
          print("❌ Live stream API returned error: $_errorMessage");
        }
      } else {
        _errorMessage = response.errorMessage ?? 'Failed to load live stream';
        print("❌ Live stream API failed: $_errorMessage");
      }
    } catch (e) {
      _errorMessage = 'Exception: $e';
      print("⚠️ Live stream Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
