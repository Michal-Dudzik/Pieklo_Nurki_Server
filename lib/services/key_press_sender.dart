import 'dart:ffi';
import 'dart:io' show Platform;

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
      _dll = DynamicLibrary.open('lib/test/key_press_sender.dll');
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
}
