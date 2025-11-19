import 'package:flutter/cupertino.dart';
import 'package:gathering_app/View/Screen/authentication_screen/log_in_screen.dart';
import 'package:gathering_app/ViewModel/event_cartModel.dart';

class SavedEventController extends ChangeNotifier {
  final List<EventCartmodel> _savedEvents = [];

  List<EventCartmodel> get savedEvents => _savedEvents;

  bool isSaved(EventCartmodel event) {
    return _savedEvents.any((event) => event.id == event.id);
  }

  void toggleSaveEvent(EventCartmodel event) {
    if (isSaved(event)) {
      _savedEvents.removeWhere((e) => e.id == event.id);
      print('${event.title} removed');
    } else {
      _savedEvents.add(event);

      print('saved');
    }
    notifyListeners();
  }
}
