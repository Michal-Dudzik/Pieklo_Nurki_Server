import 'dart:ffi'; // Import FFI definitions
import 'dart:io' show Platform; // For platform detection

typedef ConnectToBluetoothServerNativeFunc = Int32 Function();
typedef ConnectToBluetoothServerFunc = int Function();

class BluetoothServer {
  late final DynamicLibrary _lib;

  BluetoothServer() {
    // Load the appropriate library based on the platform
    if (Platform.isWindows) {
      _lib = DynamicLibrary.open('BluetoothServer.dll');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  int connectToBluetoothServer() {
    // Define the function pointer
    final ConnectToBluetoothServerFunc connectFunc = _lib
        .lookup<NativeFunction<ConnectToBluetoothServerNativeFunc>>(
            'connectToBluetoothServerNative')
        .asFunction();

    // Call the native function
    return connectFunc();
  }
}

final bluetoothServer = BluetoothServer();
