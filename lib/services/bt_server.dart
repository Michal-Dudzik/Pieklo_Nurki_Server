import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:pieklo_server_flutter/services/game_window_finder.dart';
import 'package:pieklo_server_flutter/services/key_press_sender.dart';

typedef KeyPressCallback = void Function(String command);

class BluetoothServer {
  final BluetoothServerCallback _callback;
  final BluetoothCharacteristic _characteristic;
  final BluetoothServer _server;

  BluetoothServer(this._callback, this._characteristic, this._server) {
    _server.listen(_onDataReceived);
  }

  void _onDataReceived(List<int> data) {
    String command = utf8.decode(data);
    print('Received command: $command');

    _callback(command);
  }

  void sendKeyPress(String command) {
    switch (command.toLowerCase()) {
      case 'u':
        _sendKeyPress(VK_UP);
        break;
      case 'd':
        _sendKeyPress(VK_DOWN);
        break;
      case 'l':
        _sendKeyPress(VK_LEFT);
        break;
      case 'r':
        _sendKeyPress(VK_RIGHT);
        break;
      case 't':
        _sendKeyPress(VK_CONTROL);
        break;
      case 'f':
        _sendKeyPress(VK_CONTROL);
        break;
      default:
        print('Unknown command: $command');
    }
  }

  void _sendKeyPress(int keyCode, {bool keyDown = true}) {
    int hWnd = GameWindowFinder().findGameWindow('HELLDIVERS™ 2');
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

  // void closeServer() {
  //   _server.close();
  // }
}

const VK_UP = 0x26;
const VK_DOWN = 0x28;
const VK_LEFT = 0x25;
const VK_RIGHT = 0x27;
const VK_CONTROL = 0x11;
