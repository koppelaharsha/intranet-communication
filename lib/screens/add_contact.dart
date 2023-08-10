import 'package:app11/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contacts.dart';

class AddContact extends StatefulWidget {
  static const routeName = '/add-contact';

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  bool _isInit = false;
  var contactId;
  Contact contact;
  var _formKey = GlobalKey<FormState>();

  var _wifiFocusNode = FocusNode();
  var _ipFocusNode = FocusNode();
  var _portFocusNode = FocusNode();

  @override
  void dispose() {
    _wifiFocusNode.dispose();
    _ipFocusNode.dispose();
    _portFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      contactId = ModalRoute.of(context).settings.arguments;
      contact =
          Provider.of<Contacts>(context, listen: false).getContact(contactId);
      _isInit = true;
      print(contact.id);
    }
    super.didChangeDependencies();
  }

  void _saveForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print('saving');
    print(contact.id);
    print(contact.name);
    print(contact.wifi);
    print(contact.ip);
    print(contact.port);
    if (contactId == null) {
      Provider.of<Contacts>(context, listen: false).addContact(contact);
    } else {
      Provider.of<Contacts>(context, listen: false).updateContact(contact);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    initialValue: contact.name,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_wifiFocusNode);
                    },
                    onSaved: (value) {
                      contact.name = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Wi-Fi',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    focusNode: _wifiFocusNode,
                    initialValue: contact.wifi,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_ipFocusNode);
                    },
                    onSaved: (value) {
                      contact.wifi = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'IP',
                      border: OutlineInputBorder(),
                    ),
                    focusNode: _ipFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_portFocusNode);
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    initialValue: contact.ip,
                    onSaved: (value) {
                      contact.ip = value;
                    },
                    validator: (value) {
                      var values = value.split('.');
                      var error;
                      if (values.length == 4) {
                        values.forEach((element) {
                          var elementInt = int.tryParse(element);
                          if (elementInt == null ||
                              elementInt < 0 ||
                              elementInt > 255) {
                            error = 'format should be 192.168.123.123';
                            return;
                          }
                        });
                      } else {
                        error = 'format should be 192.168.123.123';
                      }
                      return error;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Port',
                      border: OutlineInputBorder(),
                    ),
                    focusNode: _portFocusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    initialValue: contact.port.toString(),
                    validator: (value) {
                      var error;
                      var valueInt = int.tryParse(value);
                      if (valueInt == null ||
                          valueInt < 1024 ||
                          valueInt > 65535) {
                        error = 'value should be between 1025-65535';
                      }
                      return error;
                    },
                    onSaved: (value) {
                      contact.port = int.tryParse(value) ?? 1765;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
