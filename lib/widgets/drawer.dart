import 'package:app11/util/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/profile.dart';
import '../screens/add_contact.dart';
import '../screens/settings.dart';
import '../screens/about_app.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(child: Text('H')),
              accountName: Text('Harsha'),
              accountEmail: Consumer<AppSocket>(
                builder: (ctx, network, child) => Text(network.wifiIP ?? 'NA'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(UserProfile.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Add Contact'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AddContact.routeName);
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Settings.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AboutApp.routeName);
              },
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }
}
