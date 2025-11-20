// saved_event_controller.dart

import 'package:flutter/cupertino.dart';

import '../../ViewModel/event_cartModel.dart';

class SavedEventController extends ChangeNotifier {
  final List<EventCartmodel> _savedEvents = [];

  List<EventCartmodel> get savedEvents => _savedEvents;

  // এই ফাংশনটা ঠিক করো
  bool isSaved(EventCartmodel event) {
    return _savedEvents.any((e) => e.id == event.id); // এখানে id চেক করতে হবে
  }

  void toggleSave(EventCartmodel event) {
    if (isSaved(event)) {
      _savedEvents.removeWhere((e) => e.id == event.id);
      print("${event.title} removed from saved");
    } else {
      _savedEvents.add(event);
      print("${event.title} saved!");
    }
    notifyListeners(); // এটা না থাকলে UI আপডেট হবে না
  }
}