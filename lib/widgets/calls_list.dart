import 'package:app11/providers/contacts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/call.dart';
import '../providers/calls.dart';

class CallsList extends StatelessWidget {
  Widget getCallTypeIcon(CallType callType) {
    if (callType == CallType.DialledCall) return Icon(Icons.call_made);
    if (callType == CallType.RecievedCall)
      return Icon(Icons.call_received);
    else
      return Icon(Icons.call_missed);
  }

  @override
  Widget build(BuildContext context) {
    final List<Call> calls = Provider.of<Calls>(context).items;
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: CircleAvatar(
            child: getCallTypeIcon(calls[i].type),
          ),
          title: Consumer<Contacts>(
            builder: (ctx, contacts, widget) => Text(
                "${contacts.getContact(calls[i].contactId).name} [${contacts.getContact(calls[i].contactId).wifi}]"),
          ),
          subtitle:
              Text(DateFormat().add_yMMMd().add_jm().format(calls[i].dateTime)),
        );
      },
    );
  }
}
