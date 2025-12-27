import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Model/ChatModel.dart';
import 'package:gathering_app/Service/Controller/auth_controller.dart';
import 'package:gathering_app/Service/Controller/chat_controller.dart';
import 'package:gathering_app/Service/Controller/profile_page_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/user_chat_screen.dart';
import 'package:provider/provider.dart';

import '../../Widgets/serch_textfield.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = AuthController();
      if (auth.userId == null) {
         context.read<ProfileController>().fetchProfile(forceRefresh: false).then((_) {
           context.read<ChatController>().getChats();
           context.read<ChatController>().initChatListSocket();
         });
      } else {
        context.read<ChatController>().getChats();
        context.read<ChatController>().initChatListSocket();
      }
    });
  }

  @override
  void dispose() {
    context.read<ChatController>().disposeChatListSocket();
    super.dispose();
  }

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
            child: Consumer<ChatController>(
              builder: (context, controller, child) {
                if (controller.inProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.chatList.isEmpty) {
                   if (controller.errorMessage != null) {
                     return Center(child: Text(controller.errorMessage!));
                   }
                   return const Center(child: Text("No conversations yet"));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ChatController>().getChats();
                  },
                  child: ListView.builder(
                    itemCount: controller.chatList.length,
                    itemBuilder: (context, index) {
                      final userChat = controller.chatList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 26.r,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: (userChat.imageIcon != null && userChat.imageIcon!.startsWith('http'))
                              ? NetworkImage(userChat.imageIcon!)
                              : null,
                          child: (userChat.imageIcon == null || !userChat.imageIcon!.startsWith('http'))
                              ? const Icon(Icons.person, color: Colors.grey)
                              : null,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                userChat.name ?? 'Unknown',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          userChat.currentMessage ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: Text(
                          userChat.time != null ? userChat.time!.toString() : '', // Simplify formatting for now
                          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => UserChatScreen(chat: userChat)));
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}