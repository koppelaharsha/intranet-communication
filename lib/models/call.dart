import 'package:flutter/material.dart';

enum CallType {
  MissedCall,
  RecievedCall,
  DialledCall,
}

class Call with ChangeNotifier {
  int id;
  CallType type;
  int contactId;
  DateTime dateTime;
  int duration;

  Call({
    this.id,
    @required this.type,
    @required this.contactId,
    @required this.dateTime,
    @required this.duration,
  });

  update(Call call){
    this.duration = call.duration;
    notifyListeners();
  }
}
