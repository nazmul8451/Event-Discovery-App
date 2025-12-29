import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/liveStreamController.dart';
import 'package:gathering_app/Service/Controller/live_chat_controller.dart';
import 'package:gathering_app/Model/live_chat_message_model.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart'
    show ThemeProvider;
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LiveStream extends StatefulWidget {
  const LiveStream({super.key});
  static const String name = '/live-streem-screen';
  @override
  State<LiveStream> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  String? _eventId;
  final TextEditingController _chatMessageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

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
        // Fetch chat messages
        context.read<LiveChatController>().fetchMessages(streamIdToGetToken);

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
    _chatMessageController.dispose();
    _chatScrollController.dispose();
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _chatScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVideoPlayer(streamData),
                  SizedBox(height: 20.h),
                  Text(
                    'Live chat',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildChatList(streamData),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          _buildChatInput(streamData),
        ],
      ),
    );
  }

  Widget _buildChatList(Map<String, dynamic>? streamData) {
    final streamId = streamData?['id']?.toString() ?? streamData?['_id']?.toString() ?? streamData?['streamId']?.toString();
    
    return Consumer<LiveChatController>(
      builder: (context, chatCtrl, child) {
        if (chatCtrl.isLoading && chatCtrl.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (chatCtrl.messages.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                'No messages yet. Say hi!',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chatCtrl.messages.length,
          itemBuilder: (context, index) {
            final message = chatCtrl.messages[index];
            final profileController = context.read<ProfileController>();
            final currentUser = profileController.currentUser;
            final currentUserId = currentUser?.id;
            final isMyMessage = message.userId == currentUserId;

            // Use latest data from ProfileController if it's my message
            final avatarUrl = isMyMessage 
                ? (currentUser?.profileImageUrl ?? message.userProfile?.avatar)
                : message.userProfile?.avatar;
            
            final displayName = isMyMessage
                ? (currentUser?.name ?? message.userProfile?.name ?? 'Guest')
                : (message.userProfile?.name ?? 'Guest');

            return Padding(
              padding: EdgeInsets.only(bottom: 20.h), // Increased spacing
              child: GestureDetector(
                onLongPress: isMyMessage 
                    ? () => _showDeleteDialog(context, chatCtrl, message.id!, streamId)
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (message.userId != null) {
                          Navigator.pushNamed(
                            context,
                            OtherUserProfileScreen.name,
                            arguments: message.userId,
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: avatarUrl != null
                            ? CachedNetworkImageProvider(avatarUrl)
                            : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (message.userId != null) {
                                Navigator.pushNamed(
                                  context,
                                  OtherUserProfileScreen.name,
                                  arguments: message.userId,
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  message.formattedTime ?? '',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            message.message ?? '',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (streamId != null && message.id != null) {
                          chatCtrl.likeMessage(message.id!, streamId);
                        }
                      },
                      child: Column(
                        children: [
                          Icon(
                            message.hasLiked == true ? Icons.favorite : Icons.favorite_border,
                            size: 18.sp,
                            color: message.hasLiked == true ? Colors.red : Colors.grey,
                          ),
                          if ((message.likes ?? 0) > 0)
                            Text(
                              '${message.likes}',
                              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, LiveChatController chatCtrl, String messageId, String? streamId) {
    if (streamId == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await chatCtrl.deleteMessage(messageId, streamId);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message deleted')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput(Map<String, dynamic>? streamData) {
    final streamId = streamData?['id']?.toString() ?? streamData?['_id']?.toString() ?? streamData?['streamId']?.toString();
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
        bottom: bottomInset > 0 
            ? 10.h 
            : (bottomPadding > 0 ? bottomPadding : 16.h),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: TextFormField(
                controller: _chatMessageController,
                maxLines: 5,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () async {
              if (_chatMessageController.text.trim().isEmpty || streamId == null) return;
              
              final msg = _chatMessageController.text.trim();
              _chatMessageController.clear();
              
              final success = await context.read<LiveChatController>().sendMessage(streamId, msg);
              if (success) {
                // Auto scroll to bottom
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (_chatScrollController.hasClients) {
                    _chatScrollController.animateTo(
                      _chatScrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });
              }
            },
            child: Container(
              height: 44.h,
              width: 44.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFB026FF), Color(0xFFFF006E)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB026FF).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.send, color: Colors.white, size: 20.sp),
            ),
          ),
        ],
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
