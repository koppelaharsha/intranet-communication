import 'package:flutter/material.dart';

class Message with ChangeNotifier {
  int id;
  int contactId;
  int fromMe;
  String message;
  DateTime dateTime;

  Message({
    this.id,
    @required this.contactId,
    @required this.fromMe,
    @required this.message,
    @required this.dateTime
  });
}
