import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/providers/providers.dart';

import '../constants.dart';

typedef SendKeyPressFunc = Void Function(IntPtr hWnd, Int32 keyCode);
typedef SendKeyPress = void Function(int hWnd, int keyCode);

class KeyPressSender {
  SendKeyPress? _sendKeyPress;
  DynamicLibrary? _dll;

  KeyPressSender() {
    _loadLibrary();
  }

  void _loadLibrary() {
    if (Platform.isWindows) {
      _dll = DynamicLibrary.open(
          'data/flutter_assets/lib/services/dll/key_press_sender.dll');
      _sendKeyPress = _dll!.lookupFunction<SendKeyPressFunc, SendKeyPress>(
        'SendKeyPress',
      );
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void sendKeyPress(int hWnd, int keyCode) {
    if (_dll == null || _sendKeyPress == null) {
      _loadLibrary();
    }
    _sendKeyPress!(hWnd, keyCode);
  }

  void sendKeyUp(int hWnd, int keyCode) {
    if (_dll == null || _sendKeyPress == null) {
      _loadLibrary();
    }
    _sendKeyPress!(hWnd, keyCode);
  }

  void handleKeyPress(WidgetRef ref, int keyCode, {bool keyDown = true}) {
    final gameWindowFinder = ref.read(gameWindowFinderProvider);
    final gameWindowStateNotifier = ref.read(gameWindowStateProvider.notifier);

    int hWnd = gameWindowFinder.findGameWindow(GAME_TITLE);
    gameWindowStateNotifier.findGameWindow(GAME_TITLE);

    if (hWnd != 0) {
      if (keyDown) {
        sendKeyPress(hWnd, keyCode);
      } else {
        sendKeyUp(hWnd, keyCode);
      }
    } else {
      print('Game window not found.');
    }
  }
}
