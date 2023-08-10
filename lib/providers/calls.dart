import 'package:flutter/material.dart';
import '../models/call.dart';
import './database/DB.dart';

class Calls with ChangeNotifier {
  List<Call> _list = [];

  List<Call> get items {
    return [..._list];
  }

  Future<void> addCall(Call call) async {
    final db = await DB.db;
    final callId = await db.insert('calls', {
      'type': CallType.values.indexOf(call.type),
      'contact_id': call.contactId,
      'date_time': call.dateTime.toIso8601String(),
      'duration': call.duration,
    });
    call.id = callId;
    _list.insert(0, call);
    notifyListeners();
  }

  Future<void> updateCall(Call call) async {
    final index = _list.indexWhere((item) => item.id == call.id);
    if (index >= 0) {
      final db = await DB.db;
      // final rows =
      await db.update(
        'calls',
        {
          'duration': call.duration,
        },
        where: 'id = ?',
        whereArgs: [call.id],
      );
      _list[index].update(call);
      notifyListeners();
    } else {
      print('call not found');
    }
  }

  Future<void> deleteCall(int callId) async {
    final db = await DB.db;
    await db.delete('calls', where: 'id = ?', whereArgs: [callId]);
    _list.removeWhere((call) => call.id == callId);
    notifyListeners();
  }

  Future<void> deleteCalls(int contactId) async {
    final db = await DB.db;
    await db.delete('calls', where: 'contact_id = ?', whereArgs: [contactId]);
    _list.removeWhere((call) => call.contactId == contactId);
    notifyListeners();
  }

  Future<void> deleteAll() async {
    final db = await DB.db;
    await db.delete('calls');
    _list = [];
    notifyListeners();
  }

  Calls(ip) {
    print(ip);
    DB.db.then((db) => db.query('calls').then((calls) {
          calls.forEach((call) {
            _list.add(Call(
              id: call['id'],
              type: CallType.values[call['type']],
              contactId: call['contact_id'],
              dateTime: DateTime.parse(call['date_time']),
              duration: call['duration'],
            ));
          });
          notifyListeners();
        }));
  }
}
