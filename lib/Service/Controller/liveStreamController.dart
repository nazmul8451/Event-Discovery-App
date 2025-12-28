import 'package:flutter/material.dart';
import 'package:gathering_app/Service/Api%20service/network_caller.dart';
import 'package:gathering_app/Service/urls.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveStreamController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _liveStreamData;
  Map<String, dynamic>? get liveStreamData => _liveStreamData;

  Map<String, dynamic>? _agoraTokenData;
  Map<String, dynamic>? get agoraTokenData => _agoraTokenData;

  // Agora engine instance
  RtcEngine? _engine;
  RtcEngine? get engine => _engine;

  // Remote user ID (broadcaster)
  int? _remoteUid;
  int? get remoteUid => _remoteUid;

  bool _isJoined = false;
  bool get isJoined => _isJoined;

  ClientRoleType _currentRole = ClientRoleType.clientRoleAudience;
  ClientRoleType get currentRole => _currentRole;

  // Agora App ID - Replace with your actual Agora App ID
  static const String _appId = "9476d1c9b94d48f3a6f312798aa6c3a6";

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
        if (body['success'] == true) {
          final data = body['data'];
          if (data != null && data is Map) {
            _agoraTokenData = Map<String, dynamic>.from(data);
            print("✅ Agora token data loaded successfully");
            print("📊 Token length: ${_agoraTokenData?['token']?.toString()?.length}");
            print("📊 Channel Name: ${_agoraTokenData?['channelName']}");
          } else {
            _errorMessage = 'Invalid token data format from server';
            print("❌ Agora token API returned success but invalid data: $data");
          }
        } else {
          _errorMessage = body['message'] ?? 'Failed to get Agora token';
          print("❌ Agora token API returned error body: $body");
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

  // Initialize Agora Engine
  Future<void> initializeAgora({required ClientRoleType role}) async {
    print("🎙️ Initializing Agora Engine with role: $role");
    _currentRole = role;
    
    try {
      // Request permissions
      await [Permission.microphone, Permission.camera].request();

      // Create Agora engine
      _engine = createAgoraRtcEngine();
      
      await _engine!.initialize(RtcEngineContext(
        appId: _appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      // Set client role
      await _engine!.setClientRole(role: _currentRole);

      // Enable video
      await _engine!.enableVideo();

      if (_currentRole == ClientRoleType.clientRoleBroadcaster) {
        await _engine!.startPreview();
      }

      // Register event handlers
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print("🎙️ Successfully joined channel: ${connection.channelId}");
            _isJoined = true;
            notifyListeners();
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print("👤 Remote user joined: $remoteUid");
            _remoteUid = remoteUid;
            notifyListeners();
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            print("👤 Remote user offline: $remoteUid");
            _remoteUid = null;
            notifyListeners();
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            print("🎙️ Left channel");
            _isJoined = false;
            _remoteUid = null;
            notifyListeners();
          },
          onError: (ErrorCodeType err, String msg) {
            print("❌ Agora Error: $err - $msg");
            _errorMessage = "Agora Error: $msg";
            notifyListeners();
          },
        ),
      );

      print("✅ Agora Engine initialized successfully");
    } catch (e) {
      print("❌ Failed to initialize Agora: $e");
      _errorMessage = "Failed to initialize Agora: $e";
      notifyListeners();
    }
  }

  // Join channel with token
  Future<void> joinChannel() async {
    if (_engine == null) {
      print("⚠️ Agora engine not initialized");
      return;
    }

    if (_agoraTokenData == null) {
      print("⚠️ No Agora token data available");
      return;
    }

    try {
      final String token = _agoraTokenData!['token']?.toString() ?? '';
      final String channelName = _agoraTokenData!['channelName']?.toString() ?? '';
      
      // Safe parsing of UID (could be int or string from API)
      final dynamic rawUid = _agoraTokenData!['uid'];
      final int uid = int.tryParse(rawUid?.toString() ?? '0') ?? 0;

      if (token.isEmpty || channelName.isEmpty) {
        _errorMessage = "Missing token or channel name in Agora data";
        print("⚠️ Missing Agora parameters: token=$token, channel=$channelName");
        notifyListeners();
        return;
      }

      print("🎙️ Joining channel: $channelName with UID: $uid as $_currentRole");

      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: ChannelMediaOptions(
          clientRoleType: _currentRole,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
          publishMicrophoneTrack: _currentRole == ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack: _currentRole == ClientRoleType.clientRoleBroadcaster,
        ),
      );
    } catch (e) {
      print("❌ Error in joinChannel: $e");
      _errorMessage = "Failed to join channel: $e";
      notifyListeners();
    }
  }

  // Leave channel and dispose engine
  Future<void> leaveChannel() async {
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
      _isJoined = false;
      _remoteUid = null;
      print("🎙️ Left channel and disposed engine");
      notifyListeners();
    }
  }

  @override
  void dispose() {
    leaveChannel();
    super.dispose();
  }
}
