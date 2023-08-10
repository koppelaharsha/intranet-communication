import 'package:app11/providers/messages.dart';
import 'package:app11/util/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/contacts.dart';
import './providers/calls.dart';

import './screens/profile.dart';
import './screens/add_contact.dart';
import './screens/about_app.dart';
import './screens/settings.dart';
import './screens/call.dart';
import './screens/view_contact.dart';

import './widgets/drawer.dart';
import './widgets/calls_list.dart';
import './widgets/contacts_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Contacts()),
        ChangeNotifierProvider(create: (ctx) => AppSocket()),
        ChangeNotifierProxyProvider<AppSocket, Calls>(
          create: (ctx) => Calls(null),
          update: (ctx, appSocket, calls) => Calls(appSocket.newCall),
        ),
        ChangeNotifierProxyProvider<AppSocket, Messages>(
          create: (ctx) => Messages(),
          update: (ctx, appSocket, messages) => Messages(
              oldMessages: messages.items, newMessage: appSocket.newMessage),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal[800],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Callie'),
        routes: {
          UserProfile.routeName: (ctx) => UserProfile(),
          AddContact.routeName: (ctx) => AddContact(),
          Settings.routeName: (ctx) => Settings(),
          AboutApp.routeName: (ctx) => AboutApp(),
          ViewContact.routeName: (ctx) => ViewContact(),
          CallScreen.routeName: (ctx) => CallScreen()
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, initialIndex: 0, vsync: this)
      ..addListener(() {});
  }

  List<Map<String, String>> menuItems = [
    {'text': 'Add Contact'},
    {'text': 'Settings'},
  ];

  Widget mainAppBar(ctx, val) {
    return SliverAppBar(
      snap: true,
      floating: true,
      pinned: true,
      title: Text(widget.title),
      actions: [
        Consumer<AppSocket>(
          builder: (ctx, network, child) => Icon(
              network.isWifi ? Icons.signal_wifi_4_bar : Icons.signal_wifi_off),
        ),
        PopupMenuButton(itemBuilder: (ctx) {
          return menuItems
              .map((e) => PopupMenuItem(
                    child: Text(e['text']),
                  ))
              .toList();
        }),
      ],
      bottom: TabBar(
        tabs: [
          Tab(child: Text("CONTACTS")),
          Tab(child: Text("CALLS")),
        ],
        controller: tabController,
        indicatorColor: Colors.white,
      ),
      forceElevated: val,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, val) => [mainAppBar(ctx, val)],
        body: TabBarView(
          controller: tabController,
          children: [
            ContactsList(),
            CallsList(),
          ],
        ),
      ),
    );
  }
}
