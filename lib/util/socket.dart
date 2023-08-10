import 'dart:io';

import 'package:app11/models/call.dart';
import 'package:app11/models/message.dart';
import 'package:app11/providers/database/DB.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class AppSocket with ChangeNotifier {
  bool _onCall = false;
  ServerSocket _serverSocket;
  Map<int, Socket> _clientsSockets = {};
  Message _newMessage;
  Call _newCall;

  Message get newMessage {
    return _newMessage;
  }

  Call get newCall {
    return _newCall;
  }

  int get clientsSockets {
    return _clientsSockets.length;
  }

  _serverDone() {
    print("Server Done");
  }

  _serverError(error, StackTrace stackTrace) {
    print("Server Error");
    print(error);
  }

  Future<void> startServer(String ip) async {
    _serverSocket = await ServerSocket.bind(ip, 1765, shared: true);
    _serverSocket.listen(
      _handleClient,
      onDone: _serverDone,
      onError: _serverError,
    );
  }

  _clientDone(int contactId) {
    print("Client Done");
    _clientsSockets[contactId].destroy();
    _clientsSockets.remove(contactId);
    // onCall = false;
  }

  _clientError(int contactId, error, StackTrace stackTrace) {
    print("Client Error");
    print(error);
    _clientsSockets[contactId].destroy();
    _clientsSockets.remove(contactId);
    // onCall = false;
  }

  _handleClient(Socket socket) {
    // socket.write("Hello from Server\nMessage : ");
    if (_onCall) {
      socket.write("Server Busy");
      socket.destroy();
    } else {
      // onCall = true;
      DB.db.then((db) => db.query('contacts',
              where: 'ip = ?',
              whereArgs: [socket.remoteAddress.address]).then((value) {
            if (value.length != 0) {
              var contact = value[0];
              print(contact);
              return contact['id'];
            }
            return 0;
          }).then((value) {
            print(value);
            final int contactId = value;
            if (contactId == 0) {
              socket.write('Contact Not Found');
              socket.destroy();
            } else {
              _listenSocket(contactId, socket);
            }
          }));
    }
  }

  void _listenSocket(int contactId, Socket socket) {
    _clientsSockets[contactId] = socket;
    socket.listen(
      (data) {
        final message = String.fromCharCodes(data).trim();
        _receiveMessage(contactId, message);
      },
      onDone: () => _clientDone(contactId),
      onError: (error, stackTrace) =>
          _clientError(contactId, error, stackTrace),
    );
  }

  Future<Socket> _getSocket(int contactId) async {
    if (_clientsSockets.containsKey(contactId)) {
      return _clientsSockets[contactId];
    } else {
      return DB.db.then((db) => db
          .query('contacts', where: 'id = ?', whereArgs: [contactId])
          .then((contacts) => contacts[0])
          .then((contact) =>
              Socket.connect(contact['ip'], contact['port']).then((socket) {
                _listenSocket(contactId, socket);
                return socket;
              })));
    }
  }

  Future<void> sendMessage(int contactId, String message) async {
    return _getSocket(contactId).then((socket) {
      socket.write("$message\n");
      _addNewMessage(contactId, 1, message);
    });
  }

  void _receiveMessage(int contactId, String message) {
    _addNewMessage(contactId, 0, message);
  }

  void _addNewMessage(int contactId, int fromMe, String message) {
    var clientMessage = Message(
      fromMe: fromMe,
      contactId: contactId,
      message: message,
      dateTime: DateTime.now(),
    );
    _newMessage = clientMessage;
    notifyListeners();
    // _newMessage = null;
  }

  var _wifiName;
  var _wifiIP;
  bool _isWifi = false;

  String get wifiName {
    return _wifiName;
  }

  String get wifiIP {
    return _wifiIP;
  }

  bool get isWifi {
    return _isWifi;
  }

  AppSocket() {
    Connectivity().onConnectivityChanged.listen((result) {
      _init();
    }).onError((error) {
      print('error connectivity');
    });
  }

  Future<void> _init() async {
    var netStatus = await Connectivity().checkConnectivity();
    if (netStatus == ConnectivityResult.wifi) {
      print('Connected to Wifi');
      _isWifi = true;
      _wifiIP = await Connectivity().getWifiIP();
      print(_wifiIP);
    } else {
      print('Not Connected to Wifi');
      _isWifi = false;
      _wifiIP = null;
    }
    notifyListeners();
    if (_wifiIP != null) {
      startServer(_wifiIP).then((value) {
        print("Server listening on ${_serverSocket.address}");
      }).catchError((error) {
        print("Error Starting Server");
      });
    }
  }
}
