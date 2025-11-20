import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Widgets/serch_textfield.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  // পরে API থেকে আসবে – এখন হার্ডকোডেড ডামি ডাটা
  final List<Map<String, dynamic>> chats = const [
    {
      "name": "Sarah Johnson",
      "message": "Are you going to the festival?",
      "time": "10:30 AM",
      "image": "assets/images/avatar1.png",
    },
    {
      "name": "Mike Chen",
      "message": "Thanks for the recommendations!",
      "time": "Yesterday",
      "image": '',
      "isOrganizer": false,
    },
    {
      "name": "Event Organizers",
      "message": "Community updates available",
      "time": "2 days ago",
      "image": "assets/images/group_icon.png",
      "isOrganizer": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      // AppBar (Messages + Search)
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("Messages",style: Theme.of(context).textTheme.titleLarge,),
              Text('Connect with Community',style: Theme.of(context).textTheme.titleMedium,)
            ],
          ),
        ),

      ),

      // Body
      body: Column(
        children: [
          // Search Bar
          SearchTextField(hintText: 'Search Conversation...',),

          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 26.r,
                    backgroundImage: AssetImage(chat["image"]),
                    child: chat["image"] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Row(
                    children: [
                      Text(
                        chat["name"],
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
                      ),
                      if (chat["isOrganizer"] == true) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.pink[100],
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "Organizer",
                            style: TextStyle(color: Colors.pink[800], fontSize: 10.sp),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    chat["message"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    chat["time"],
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  onTap: () {
                    // পরে Chat Details Screen এ নিয়ে যাবে
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(chat: chat)));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}