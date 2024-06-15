import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/command_handler.dart';

typedef ServerAddressCallback = void Function(String ip, int port);
typedef ClientStatusCallback = void Function(bool clientConnected);

class TcpServer {
  ServerSocket? serverSocket;
  Socket? clientSocket;
  final WidgetRef ref;

  TcpServer(this.ref);

  Future<String> _getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );

    for (var interface in interfaces) {
      for (var address in interface.addresses) {
        if (!address.isLoopback) {
          return address.address;
        }
      }
    }
    return '0.0.0.0'; // Fallback in case no address is found
  }

  void startServer(ServerAddressCallback onAddressUpdate,
      ClientStatusCallback onClientStatusUpdate) async {
    final String? ip = await _getLocalIpAddress();
    if (ip == null) {
      print('Could not find a suitable IP address.');
      return;
    }

    serverSocket = await ServerSocket.bind(ip, 5000);

    onAddressUpdate(serverSocket!.address.address, 5000);

    serverSocket!.listen((Socket socket) {
      if (clientSocket == null) {
        clientSocket = socket;

        clientSocket!.write('Connection established');
        clientSocket!.flush();

        onClientStatusUpdate(true);

        clientSocket!.listen(
          (List<int> data) {
            String message = utf8.decode(data);
            handleCommand(ref, message);
          },
          onDone: () {
            onClientStatusUpdate(false);
            clientSocket = null;
          },
        );
      } else {
        print(
            'Another client tried to connect, but a client is already connected.');
        socket.destroy();
      }
    });
  }

  void stopServer() {
    clientSocket?.write('STOP');
    clientSocket?.flush();
    serverSocket?.close();
    clientSocket?.close();
  }
}
