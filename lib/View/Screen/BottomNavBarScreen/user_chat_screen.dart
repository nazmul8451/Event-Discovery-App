import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gathering_app/Model/ChatModel.dart';

class UserChatScreen extends StatefulWidget {
  ChatModel? chat;

  UserChatScreen({super.key, this.chat});

  static const String name = '/user-chat-screen';

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,

        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 0,
          title: Row(
            children: [
              // Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),

              // Profile Picture + Online Dot
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: SvgPicture.asset(
                        "${widget.chat?.imageIcon}",
                        fit: BoxFit.cover,
                        placeholderBuilder: (_) =>
                            const Icon(Icons.person, size: 24),
                      ),
                    ),
                  ),
                  // Online Dot
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      height: 12.h,
                      width: 12.w,
                      decoration: BoxDecoration(
                        color: widget.chat?.status == 'online'
                            ? Colors.green
                            : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 12.w),

              // এখানেই ম্যাজিক → নাম + স্ট্যাটাস
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${widget.chat?.name}",
                      style: TextStyle(
                        fontSize: 14.sp.clamp(14, 16),
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.chat?.status == 'online' ? 'online' : 'offline',
                      style: TextStyle(
                        fontSize: 12.sp.clamp(12, 14),
                        color: widget.chat?.status == 'online'
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.call_outlined)),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam_outlined),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            SizedBox(width: 8.w),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.image_outlined),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 70,
                        decoration: BoxDecoration(
                          /////
                          ////
                        ),
                        child: TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          textAlignVertical: TextAlignVertical.center,     // হিন্ট + টেক্সট মাঝে থাকবে
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                              vertical: 10.h
                            ),
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                50.r,
                              ), 
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
