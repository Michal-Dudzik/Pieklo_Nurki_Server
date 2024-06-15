import 'dart:convert';
import 'dart:io';

import 'package:pieklo_server_flutter/services/game_window_finder.dart';
import 'package:pieklo_server_flutter/services/key_press_sender.dart';

typedef ServerAddressCallback = void Function(String ip, int port);
typedef ClientStatusCallback = void Function(bool clientConnected);

ServerSocket? serverSocket;
Socket? clientSocket;
GameWindowFinder gameWindowFinder = GameWindowFinder();
KeyPressSender keyPressSender = KeyPressSender();

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
  print('Server running on IP: ${serverSocket!.address.address} Port: 5000');

  onAddressUpdate(serverSocket!.address.address, 5000);

  serverSocket!.listen((Socket socket) {
    if (clientSocket == null) {
      clientSocket = socket;
      print(
          'Client connected: ${clientSocket!.remoteAddress.address}:${clientSocket!.remotePort}');

      clientSocket!.write('Connection established');
      clientSocket!.flush();

      onClientStatusUpdate(true);

      clientSocket!.listen(
        (List<int> data) {
          String message = utf8.decode(data);
          print('Message from client: $message');

          switch (message) {
            case 'U':
              sendKeyPress(VK_UP);
              break;
            case 'D':
              sendKeyPress(VK_DOWN);
              break;
            case 'L':
              sendKeyPress(VK_LEFT);
              break;
            case 'R':
              sendKeyPress(VK_RIGHT);
              break;
            case 'T':
              sendKeyPress(VK_CONTROL, keyDown: true);
              break;
            case 'F':
              sendKeyPress(VK_CONTROL, keyDown: false);
              break;
            default:
              print('Unknown command: $message');
          }
        },
        onDone: () {
          print('Client disconnected');
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

void sendKeyPress(int keyCode, {bool keyDown = true}) {
  int hWnd = gameWindowFinder.findGameWindow('HELLDIVERS™ 2');
  if (hWnd != 0) {
    if (keyDown) {
      keyPressSender.sendKeyPress(hWnd, keyCode);
    } else {
      keyPressSender.sendKeyUp(hWnd, keyCode);
    }
  } else {
    print('Game window not found.');
  }
}

const VK_UP = 0x26;
const VK_DOWN = 0x28;
const VK_LEFT = 0x25;
const VK_RIGHT = 0x27;
const VK_CONTROL = 0x11;
