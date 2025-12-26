import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/Service/Controller/other_user_profile_controller.dart';
import 'package:gathering_app/Model/ChatModel.dart';
import 'package:gathering_app/Service/Controller/chat_controller.dart';
import 'package:gathering_app/View/Screen/BottomNavBarScreen/user_chat_screen.dart';
import 'package:gathering_app/View/Theme/theme_provider.dart';
import 'package:provider/provider.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String userId;
  const OtherUserProfileScreen({super.key, required this.userId});

  static const String name = '/other-user-profile';

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OtherUserProfileController>().fetchUserProfile(
        widget.userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image(image: AssetImage('assets/images/instagram.png')),
            ),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<OtherUserProfileController>(
        builder: (context, controller, child) {
          if (controller.inProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          final user = controller.userProfile;
          if (user == null) {
            return const Center(child: Text("User not found"));
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100.h,
                          width: 100.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Provider.of<ThemeProvider>(context).isDarkMode
                                ? Colors.grey[500]
                                : Colors.grey[200],
                            border: Border.all(width: 2, color: Colors.black),
                            image: user.profileImageUrl != null &&
                                    user.profileImageUrl!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(user.profileImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: user.profileImageUrl == null ||
                                  user.profileImageUrl!.isEmpty
                              ? Icon(Icons.person, size: 50.sp, color: Colors.grey[800])
                              : null,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? 'Unknown',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                user.email ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                user.description ?? '',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(context, '${user.stats?.events ?? 0}', 'Events'),
                        _buildStatColumn(context, '${user.stats?.followers ?? 0}', 'Followers'),
                        _buildStatColumn(context, '${user.stats?.following ?? 0}', 'Following'),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 48),
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Follow',
                              style: TextStyle(fontSize: 15.sp, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Consumer<ChatController>(
                            builder: (context, chatController, child) {
                              return SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 48),
                                    backgroundColor:
                                        Provider.of<ThemeProvider>(context)
                                                .isDarkMode
                                            ? Colors.grey[800]
                                            : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final chatId = await chatController
                                        .createChat(widget.userId);

                                    if (chatId != null) {
                                      final user = controller.userProfile;
                                      final chat = ChatModel(
                                        id: chatId,
                                        name: user?.name,
                                        imageIcon: user?.profileImageUrl,
                                        status: 'offline',
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              UserChatScreen(chat: chat),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            chatController.errorMessage ??
                                                "Failed to create chat",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: chatController.inProgress
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          'Message',
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.white),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),

                  ],
                ),
                    SizedBox(height: 20.h),
                    
                    /// Favorite Spots Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'FAVORITE SPOTS',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    
                    // Note: Favorite lists are usually private or separate API. 
                    // Showing a placeholder for now as requested to keep structure.
                    SizedBox(
                      height: 50.h,
                      child: Center(
                        child: Text(
                          'No public favorites to show',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 5.h),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.grey
                    : Colors.black,
              ),
        ),
      ],
    );
  }
}

