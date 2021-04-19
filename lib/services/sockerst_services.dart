
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServicesStatus {
  Online,
  Offline,
  Connecting
}

class SocketServices with ChangeNotifier{
  ServicesStatus _servicesStatus = ServicesStatus.Connecting;
  IO.Socket _socket;

  ServicesStatus get servicesStatus => this._servicesStatus;
  IO.Socket get socket => this._socket;

  
  SocketServices(){
    this._initConfig();
  }

  void _initConfig(){
    
     // Dart client
     print('0entro al intiConfig');
    _socket = IO.io('http://192.168.100.117:3000/',{//192.168.100.117
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.on('connect',(_) {
     print('connect');
     this._servicesStatus = ServicesStatus.Online;
     notifyListeners();
    });
    _socket.on('disconnect',(_) {
     print('disconnect');
     this._servicesStatus = ServicesStatus.Offline;
     notifyListeners();
    });

    // _socket.on('nuevo-mensaje',( payload) {
    //  print('nuevo-mensaje: $payload');
    // });

  }
}