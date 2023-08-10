import 'package:app11/models/call.dart';
import 'package:app11/providers/calls.dart';
import 'package:app11/providers/contacts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallScreen extends StatefulWidget {
  static const routeName = '/call';
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final contactId = ModalRoute.of(context).settings.arguments;
      if (contactId == null) {
        Navigator.of(context).pop();
      }
      final contact =
          Provider.of<Contacts>(context, listen: false).getContact(contactId);
      var call = Call(
        type: CallType.DialledCall,
        contactId: contact.id,
        dateTime: DateTime.now(),
        duration: 0,
      );
      Provider.of<Calls>(context, listen: false).addCall(call);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, val) => [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.5,
            pinned: true,
          ),
        ],
        body: Container(
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.call_end,
                color: Colors.red,
              ),
              iconSize: 48,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}
