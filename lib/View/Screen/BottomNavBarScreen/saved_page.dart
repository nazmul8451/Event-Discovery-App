import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gathering_app/View/Widgets/custom_item_container.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              SizedBox(height: 10.h,),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 7 / 9,
                  ),
                  itemBuilder: (context, index) {
                    // return Custom_item_container(event: ,);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
