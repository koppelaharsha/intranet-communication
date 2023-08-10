import 'package:flutter/material.dart';

class Contact with ChangeNotifier {
  int id;
  String name;
  String wifi;
  String ip;
  int port;

  Contact({
    this.id,
    @required this.name,
    @required this.wifi,
    @required this.ip,
    @required this.port,
  });

  update(Contact contact){
    this.name = contact.name;
    this.wifi = contact.wifi;
    this.ip = contact.ip;
    this.port = contact.port;
    notifyListeners();
  }
}
