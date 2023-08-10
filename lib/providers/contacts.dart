import 'package:flutter/material.dart';
import '../models/contact.dart';
import './database/DB.dart';

class Contacts with ChangeNotifier {
  List<Contact> _list = [];

  List<Contact> get items {
    return [..._list];
  }

  int getContactId(ip){
    final index =  _list.indexWhere((contact) => contact.ip == ip);
    if(index!=-1){
      return _list[index].id;
    }
    return null;
  }

  Contact getContact(int contactId) {
    Contact newContact = Contact(
      name: '',
      wifi: '',
      ip: '',
      port: 1765,
    );
    if (contactId == null) {
      return newContact;
    }
    return _list.firstWhere(
      (contact) => contact.id == contactId,
      orElse: () => newContact,
    );
  }

  Future<void> addContact(Contact contact) async {
    final db = await DB.db;
    final contactId = await db.insert('contacts', {
      'name': contact.name,
      'wifi': contact.wifi,
      'ip': contact.ip,
      'port': contact.port,
    });
    contact.id = contactId;
    _list.add(contact);
    notifyListeners();
  }

  Future<void> updateContact(Contact contact) async {
    final index = _list.indexWhere((item) => item.id == contact.id);
    if (index >= 0) {
      final db = await DB.db;
      // final rows = 
      await db.update(
        'contacts',
        {
          'name': contact.name,
          'wifi': contact.wifi,
          'ip': contact.ip,
          'port': contact.port,
        },
        where: 'id = ?',
        whereArgs: [contact.id],
      );
      _list[index].update(contact);
      notifyListeners();
    } else {
      print('contact not found');
    }
  }

  Future<void> deleteContact(int contactId) async {
    final db = await DB.db;
    await db.delete('contacts', where: 'id = ?', whereArgs: [contactId]);
    _list.removeWhere((contact) => contact.id == contactId);
    notifyListeners();
  }

  Future<void> deleteAll() async {
    final db = await DB.db;
    await db.delete('contacts');
    _list = [];
    notifyListeners();
  }

  Contacts() {
    DB.db.then((db) => db.query('contacts').then((contacts) {
          contacts.forEach((contact) {
            _list.add(Contact(
              id: contact['id'],
              name: contact['name'],
              wifi: contact['wifi'],
              ip: contact['ip'],
              port: contact['port'],
            ));
          });
          notifyListeners();
        }));
  }
}
