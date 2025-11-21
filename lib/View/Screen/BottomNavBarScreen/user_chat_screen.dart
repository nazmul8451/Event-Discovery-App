import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({
    super.key,
    required Map<String, dynamic> chat,
  });

  static const String name = '/user-chat-screen';

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Row(children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back)),
              Stack(
                children:[
                  CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Colors.grey[300],
                ),
                  Positioned(
                   bottom: 1,
                    right: 1,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),

                      constraints: const BoxConstraints(minHeight: 10, minWidth: 10),
                    ),
                  ),
                ]
              ),
              SizedBox(width: 12.w),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Rimon Islam', // পরে chat["name"] থেকে নিবে
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Online', // পরে স্ট্যাটাস থেকে নিবে
                      style: TextStyle(fontSize: 12.sp, color: Colors.green),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.phone_outlined,color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,)),
              IconButton(onPressed: (){}, icon: Icon(Icons.videocam_outlined,color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,)),
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black)),
            ],)
          ],
        ),
      ),
    );
  }
}
