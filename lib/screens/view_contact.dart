import 'package:app11/models/message.dart';
import 'package:app11/providers/messages.dart';
import 'package:app11/screens/add_contact.dart';
import 'package:app11/util/socket.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import './call.dart';

class ViewContact extends StatelessWidget {
  static const routeName = '/view-contact';

  @override
  Widget build(BuildContext context) {
    void _popUpClick(value) {
      if (value == 'delete') {
        Navigator.of(context).pop('delete');
      }
    }

    final contact = ModalRoute.of(context).settings.arguments as Contact;
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CallScreen.routeName, arguments: contact.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddContact.routeName, arguments: contact.id);
            },
          ),
          PopupMenuButton<String>(
            shape: Border.all(style: BorderStyle.none),
            padding: EdgeInsets.all(0),
            onSelected: _popUpClick,
            itemBuilder: (ctx) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Contact'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFECE5DD),
        child: Column(
          children: [
            Expanded(
              child: Consumer<Messages>(builder: (ctx, messages, child) {
                List<Message> contactMessages =
                    messages.contactMessages(contact.id);
                return ListView.builder(
                  itemCount: contactMessages.length,
                  itemBuilder: (ctx, i) {
                    return Bubble(
                      margin: BubbleEdges.symmetric(vertical: 4),
                      child: Text(contactMessages[i].message),
                      alignment: contactMessages[i].fromMe == 1
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      color: contactMessages[i].fromMe == 1
                          ? Color.fromRGBO(225, 255, 199, 1.0)
                          : Colors.white,
                    );
                  },
                  reverse: true,
                );
              }),
            ),
            Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: MessageInput(contact.id),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageInput extends StatefulWidget {
  final int contactId;
  MessageInput(this.contactId);
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  var inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: inputController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 2,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Type a Message',
              contentPadding: EdgeInsets.all(4),
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.all(0),
          icon: CircleAvatar(
            child: Icon(Icons.send),
          ),
          onPressed: () {
            var message = inputController.text.trim();
            if (message.isNotEmpty) {
              Provider.of<AppSocket>(context, listen: false)
                  .sendMessage(widget.contactId, message)
                  .then((value) {
                inputController.text = '';
              }).catchError((error) {
                print('error sending message');
              });
            }
          },
        ),
      ],
    );
  }
}
