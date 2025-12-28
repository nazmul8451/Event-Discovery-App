import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/liveStreamController.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart'
    show ThemeProvider;
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class LiveStream extends StatefulWidget {
  const LiveStream({super.key});
  static const String name = '/live-streem-screen';
  @override
  State<LiveStream> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final eventId = args?['eventId']?.toString();
      
      if (eventId != null) {
        print("🎬 LiveStream screen received eventId: $eventId");
        final controller = context.read<LiveStreamController>();
        
        // Call getLiveStreamByEventId and wait for it to complete
        await controller.getLiveStreamByEventId(eventId);
        
        // After getting live stream data, extract streamId and call getAgoraToken
        final streamData = controller.liveStreamData;
        print("🎬 Live stream data: $streamData");
        
        if (streamData != null) {
          // Try 'id' first, then fallback to '_id'
          final streamId = streamData['id']?.toString() ?? streamData['_id']?.toString();
          print("🎬 Extracted streamId: $streamId");
          
          if (streamId != null) {
            print("🎬 Calling getAgoraToken with streamId: $streamId");
            await controller.getAgoraToken(streamId);
            
            // Initialize Agora and join channel
            await controller.initializeAgora();
            await controller.joinChannel();
          } else {
            print("⚠️ No streamId (id or _id) found in live stream data");
            print("⚠️ Available keys in streamData: ${streamData.keys.toList()}");
          }
        } else {
          print("⚠️ Live stream data is null");
        }
      } else {
        print("⚠️ No eventId provided to LiveStream screen");
      }
    });
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

                  SizedBox(height: 10.h),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'brianna',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Color(0xFFFF006E)),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'this DJ is crazy rn',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Text(
                            'jayhou',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Color(0xFFFF006E)),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            "pull up by 12 or it's packed",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Text(
                            'kevo713',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Color(0xFFFF006E)),
                          ),

                          SizedBox(width: 3.w),
                          Text(
                            'section by the bar looks lit',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
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
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          hintText: 'Type a message...',
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
            if (isLive && controller.remoteUid != null && controller.engine != null)
              // Show Agora remote video
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
              // Show placeholder when not live
              Container(
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
              ),

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
