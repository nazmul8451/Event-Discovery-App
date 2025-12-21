import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Widgets/custom_item_container.dart';
import 'package:gathering_app/View/view_controller/saved_event_controller.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  // EventCartmodel event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10.h),
              Text(
                '2 events saved',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 10.h),
              // Expanded(
              //   child: Consumer<SavedEventController>(
              //     builder:(context,controller,child) {
              //     // return  GridView.builder(
              //     //     itemCount:controller.savedEvents.length,
              //     //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     //       crossAxisCount: 2,
              //     //       mainAxisSpacing: 10,
              //     //       crossAxisSpacing: 10,
              //     //       childAspectRatio: 7 / 9,
              //     //     ),
              //     //     itemBuilder: (context, index) {
              //     //       return Consumer<SavedEventController>(
              //     //         builder: (context, controller, child) {
              //     //           final saveEventList = controller.savedEvents;
              //     //           // return Custom_item_container(
              //     //           //   // event: ,
              //     //           //   // event: saveEventList[index],
              //     //           // );
              //     //         },
              //     //       );
              //     //     },
              //     //   );
              //     }
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
