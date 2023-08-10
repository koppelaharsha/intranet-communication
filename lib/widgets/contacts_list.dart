import 'package:app11/providers/calls.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../providers/contacts.dart';

import '../screens/view_contact.dart';

class ContactsList extends StatelessWidget {
  Future<void> deleteContact(ctx, contactId) async {
    Provider.of<Contacts>(ctx, listen: false).deleteContact(contactId);
    Provider.of<Calls>(ctx, listen: false).deleteCalls(contactId);
  }

  @override
  Widget build(BuildContext context) {
    final List<Contact> contacts = Provider.of<Contacts>(context).items;
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(contacts[i].name[0]),
          ),
          title: Text(contacts[i].name),
          subtitle: Text(contacts[i].wifi),
          onTap: () {
            Navigator.of(context)
                .pushNamed(ViewContact.routeName, arguments: contacts[i])
                .then((action) {
              if (action == 'delete') {
                deleteContact(context, contacts[i].id);
              }
            });
          },
        );
      },
    );
  }
}
