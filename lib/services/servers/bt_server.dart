import 'dart:ffi';
import 'dart:io' show Platform;

typedef ConnectToBluetoothServerNativeFunc = Int32 Function();
typedef ConnectToBluetoothServerFunc = int Function();

class BluetoothServer {
  late final DynamicLibrary _lib;

  BluetoothServer() {
    if (Platform.isWindows) {
      _lib = DynamicLibrary.open('BluetoothServer.dll');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  int connectToBluetoothServer() {
    final ConnectToBluetoothServerFunc connectFunc = _lib
        .lookup<NativeFunction<ConnectToBluetoothServerNativeFunc>>(
            'connectToBluetoothServerNative')
        .asFunction();

    return connectFunc();
  }
}

final bluetoothServer = BluetoothServer();

//maybe in the future connection via bt will be added, not now though
// native code will need to be made, probably based on this repo https://github.com/Kilemonn/Cpp-SocketLibrary/tree/master?tab=Apache-2.0-1-ov-file#readme
