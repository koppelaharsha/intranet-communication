import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contacts.dart';
import '../providers/calls.dart';
import '../providers/messages.dart';
import '../util/socket.dart';

class Settings extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text('Contacts:')),
                  Consumer<Contacts>(
                    builder: (ctx, contacts, child) =>
                        Text("${contacts.items.length}"),
                  )
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text('Calls:')),
                  Consumer<Calls>(
                    builder: (ctx, calls, child) =>
                        Text("${calls.items.length}"),
                  )
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text('Messages:')),
                  Consumer<Messages>(
                    builder: (ctx, messages, child) =>
                        Text("${messages.items.length}"),
                  )
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Text('Sockets:')),
                  Consumer<AppSocket>(
                    builder: (ctx, socket, child) =>
                        Text("${socket.clientsSockets}"),
                  )
                ],
              ),
            ),
          ),
          DeleteAllData(),
        ],
      ),
    );
  }
}

class DeleteAllData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Delete All Data'),
        onPressed: () async {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Deleting All Data ...'),
            duration: Duration(seconds: 2),
          ));
          await Provider.of<Calls>(context, listen: false).deleteAll();
          await Provider.of<Contacts>(context, listen: false).deleteAll();
          await Provider.of<Messages>(context, listen: false).deleteAll();
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Deleted All Data'),
            duration: Duration(milliseconds: 500),
          ));
        },
      ),
    );
  }
}
