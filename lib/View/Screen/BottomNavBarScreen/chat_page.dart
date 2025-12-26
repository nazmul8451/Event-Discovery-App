import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gathering_app/Model/ChatModel.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/user_chat_screen.dart';

import '../../Widgets/serch_textfield.dart';

class ChatPage extends StatelessWidget {
   ChatPage({super.key});

  // পরে API থেকে আসবে – এখন হার্ডকোডেড ডামি ডাটা
  final List<Map<String, dynamic>> chats = const [

  ];
   final List<ChatModel> userChats = [
   ChatModel(
   name: 'Rimon Islam',
   currentMessage: 'Hello kemon aco?',
   id: '01',
   imageIcon: 'assets/images/person_svg.svg', // .svg হলে AssetImage এ সমস্যা হতে পারে
   isGroup: false,
   status: 'online',
   time: '4:32',
   ),
   ChatModel(
   name: 'Ayesha Khan',
   currentMessage: 'Ki khobor?',
   id: '02',
   imageIcon: 'assets/images/person_svg.svg',
   isGroup: false,
   status: 'offline',
   time: '12:15',
   ),
   ChatModel(
   name: 'Festival Organizers',
   currentMessage: 'Welcome to the group!',
   id: '03',
   imageIcon: 'assets/images/group_svg.svg',
   isGroup: true,
   status: 'online',
   time: 'Yesterday',
   ),
     ChatModel(
       name: 'Marup Vai',
       currentMessage: 'Hello Rimon',
       id: '03',
       imageIcon: 'assets/images/person_svg.svg',
       isGroup: true,
       status: 'offline',
       time: 'Yesterday',
     )
   ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // AppBar (Messages + Search)
      appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,

        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("Messages",style: Theme.of(context).textTheme.titleLarge,),
              Text('Connect with Community',style: Theme.of(context).textTheme.titleSmall,)
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
              itemCount: userChats.length,
              itemBuilder: (context, index) {
                final userChat = userChats[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 26.r,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: SvgPicture.asset(

                        "${userChat.imageIcon}",
                        width: 30.w,
                        height: 30.h,
                        fit: BoxFit.cover,
                        placeholderBuilder: (context) => const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        userChat.name as String,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                      ),
                      // if (userChatchat["isOrganizer"] == true) ...[
                      //   SizedBox(width: 6.w),
                      //   Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      //     decoration: BoxDecoration(
                      //       color: Colors.pink[100],
                      //       borderRadius: BorderRadius.circular(12.r),
                      //     ),
                      //     child: Text(
                      //       "Organizer",
                      //       style: TextStyle(color: Colors.pink[800], fontSize: 10.sp),
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                  subtitle: Text(
                    userChat.currentMessage as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Text(
                    userChat.time as String,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => UserChatScreen(chat: userChat)));
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