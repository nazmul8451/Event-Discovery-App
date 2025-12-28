import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/liveStreamController.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart'
    show ThemeProvider;
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class LiveStream extends StatefulWidget {
  const LiveStream({super.key});
  static const String name = '/live-streem-screen';
  @override
  State<LiveStream> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  String? _eventId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      _eventId = args?['eventId']?.toString();
      
      if (_eventId != null) {
        _loadStreamData();
      } else {
        print("⚠️ No eventId provided to LiveStream screen");
      }
    });
  }

  Future<void> _loadStreamData() async {
    if (_eventId == null) return;
    print("🎬 Loading live stream data for eventId: $_eventId");
    
    if (!mounted) return;
    final controller = context.read<LiveStreamController>();
    
    // Call getLiveStreamByEventId and wait for it to complete
    await controller.getLiveStreamByEventId(_eventId!);
    
    if (!mounted || controller.errorMessage != null) return;
    
    // After getting live stream data, extract stream IDs
    final streamData = controller.liveStreamData;
    
    if (streamData != null) {
      // Prioritize resource ID for token API, but keep others as fallback
      final resourceId = streamData['id']?.toString() ?? streamData['_id']?.toString();
      final alternateId = streamData['streamId']?.toString();
      
      final streamIdToGetToken = resourceId ?? alternateId;
      
      final streamerId = streamData['streamer']?.toString();
      final isLive = streamData['isLive'] == true;
      final streamStatus = streamData['streamStatus']?.toString().toLowerCase();
      
      // Get current user ID
      final profileController = context.read<ProfileController>();
      final currentUserId = profileController.currentUser?.id;
      
      print("👤 Streamer ID: $streamerId, Current User ID: $currentUserId, isLive: $isLive, Status: $streamStatus");
      
      final role = (streamerId != null && currentUserId != null && streamerId == currentUserId)
          ? ClientRoleType.clientRoleBroadcaster
          : ClientRoleType.clientRoleAudience;
          
      // 🔥 FIX: If stream is not live and user is audience, don't try to join Agora
      if (role == ClientRoleType.clientRoleAudience && !isLive) {
        print("ℹ️ Stream is not live. Skipping Agora join for audience member.");
        return;
      }

      print("🔑 Using streamId for token: $streamIdToGetToken (ResourceID: $resourceId, AltID: $alternateId)");
          
      if (streamIdToGetToken != null) {
        await controller.getAgoraToken(streamIdToGetToken);
        if (!mounted || controller.errorMessage != null) return;
        
        await controller.initializeAgora(role: role);
        if (!mounted || controller.errorMessage != null) return;
        
        await controller.joinChannel();
      } else {
        print("⚠️ No valid stream ID found in stream data");
      }
    }
  }

  @override
  void dispose() {
    // Leave channel and cleanup Agora engine
    context.read<LiveStreamController>().leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveStreamController>(
      builder: (context, liveStreamCtrl, child) {
        if (liveStreamCtrl.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (liveStreamCtrl.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${liveStreamCtrl.errorMessage}'),
            ),
          );
        }

        final streamData = liveStreamCtrl.liveStreamData;

        return _buildLiveStreamUI(context, streamData);
      },
    );
  }

  Widget _buildLiveStreamUI(BuildContext context, Map<String, dynamic>? streamData) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<ThemeProvider>(
                    builder: (context, controller, child) => GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: controller.isDarkMode
                              ? Color(0xFF3E043F)
                              : Color(0xFF686868),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/cross_icon.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, controller, child) => GestureDetector(
                      onTap: () => _loadStreamData(),
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: controller.isDarkMode
                              ? Color(0xFF3E043F)
                              : Color(0xFF686868),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildVideoPlayer(streamData),

              SizedBox(height: 20.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live chat'),

                  Text('Live chat (Coming Soon)'),

                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      'Live chat will be available in the next update.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 70,
                      decoration: BoxDecoration(),
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          enabled: false,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          hintText: 'Chat disabled...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10, left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFB026FF), Color(0xFFFF006E)],
                      ),
                    ),
                    height: 45,
                    width: 45,
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(Map<String, dynamic>? streamData) {
    final controller = context.watch<LiveStreamController>();
    final isLive = streamData?['isLive'] == true;
    final title = streamData?['title'] ?? 'Live Stream';
    final description = streamData?['description'] ?? '';
    final currentViewers = streamData?['currentViewers'] ?? 0;
    final streamStatus = streamData?['streamStatus'] ?? 'scheduled';

    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Video player or placeholder
            if (controller.isJoined && controller.engine != null && (controller.agoraTokenData?['channelName']?.isNotEmpty ?? false))
              if (controller.currentRole == ClientRoleType.clientRoleBroadcaster)
                // Show Broadcaster's local video
                AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: controller.engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
              else if (controller.remoteUid != null)
                // Show Audience's remote video
                AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.engine!,
                    canvas: VideoCanvas(uid: controller.remoteUid),
                    connection: RtcConnection(
                      channelId: controller.agoraTokenData?['channelName'] ?? '',
                    ),
                  ),
                )
              else
                // Audience is waiting for broadcaster to start
                _buildWaitingPlaceholder(isLive, streamStatus, description)
            else
              // Not joined or not live
              _buildWaitingPlaceholder(isLive, streamStatus, description),

            // Live indicator and info overlay
            Positioned(
              top: 12.h,
              left: 12.w,
              right: 12.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Live badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isLive ? Color(0xFFFB2C36) : Colors.grey[700],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLive)
                          Container(
                            height: 8.h,
                            width: 8.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (isLive) SizedBox(width: 5.w),
                        Text(
                          isLive ? 'LIVE' : streamStatus.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Viewer count
                  if (isLive)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '$currentViewers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Title overlay at bottom
            Positioned(
              bottom: 12.h,
              left: 12.w,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingPlaceholder(bool isLive, String streamStatus, String description) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLive ? Icons.videocam_off : Icons.schedule,
              size: 60.sp,
              color: Colors.white54,
            ),
            SizedBox(height: 16.h),
            Text(
              isLive
                  ? 'Waiting for broadcaster...'
                  : streamStatus == 'scheduled'
                      ? 'Stream Scheduled'
                      : 'Stream Not Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            if (description.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
