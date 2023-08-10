import 'package:flutter/material.dart';
import 'package:app11/models/message.dart';
import 'package:app11/providers/database/DB.dart';

class Messages with ChangeNotifier {
  List<Message> _list = [
    // Message(
    //     contactId: 1,
    //     fromMe: 0,
    //     message: 'Hello Harsha Vardhan Reddy Koppela Harsha',
    //     dateTime: DateTime.now()),
    // Message(
    //     contactId: 1,
    //     fromMe: 1,
    //     message: 'Hello Harsha Vardhan Reddy Koppela Harsha',
    //     dateTime: DateTime.now()),
  ];

  List<Message> get items {
    return [..._list];
  }

  void addMessage(Message newMessage) async {
    final db = await DB.db;
    final messageId = await db.insert('messages', {
      'from_me': newMessage.fromMe,
      'contact_id': newMessage.contactId,
      'message': newMessage.message,
      'date_time': newMessage.dateTime.toIso8601String(),
    });
    newMessage.id = messageId;
    _list.insert(0, newMessage);
    notifyListeners();
  }

  List<Message> contactMessages(int contactId) {
    return _list.where((message) => message.contactId == contactId).toList();
  }

  Future<void> deleteMessages(contactId) async {
    final db = await DB.db;
    await db
        .delete('messages', where: 'contact_id = ?', whereArgs: [contactId]);
    _list.removeWhere((message) => message.contactId = contactId);
    notifyListeners();
  }

  Future<void> deleteAll() async {
    final db = await DB.db;
    await db.delete('messages');
    _list = [];
    notifyListeners();
  }

  Messages({List<Message> oldMessages, Message newMessage}) {
    if (newMessage != null) {
      _list = oldMessages;
      addMessage(newMessage);
      return;
    }
    if (oldMessages == null) {
      DB.db.then((db) => db.query('messages').then((messages) {
            messages.forEach((message) {
              print(message);
              _list.insert(
                0,
                Message(
                  id: message['id'],
                  contactId: message['contact_id'],
                  fromMe: message['from_me'],
                  message: message['message'],
                  dateTime: DateTime.parse(message['date_time']),
                ),
              );
            });
            notifyListeners();
          }));
    }
  }
}
