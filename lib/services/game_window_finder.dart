import 'dart:ffi';
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';

typedef FindWindowByTitleFunc = IntPtr Function(Pointer<Utf16> windowTitle);
typedef FindWindowByTitle = int Function(Pointer<Utf16> windowTitle);

class GameWindowFinder {
  FindWindowByTitle? _findWindowByTitle;
  DynamicLibrary? _dll;

  GameWindowFinder() {
    _loadLibrary();
  }

  void _loadLibrary() {
    if (Platform.isWindows) {
      _dll = DynamicLibrary.open('lib/services/game_finder.dll');
      _findWindowByTitle =
          _dll!.lookupFunction<FindWindowByTitleFunc, FindWindowByTitle>(
        'FindWindowByTitle',
      );
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  int findGameWindow(String windowTitle) {
    if (_dll == null || _findWindowByTitle == null) {
      _loadLibrary();
    }

    final windowTitlePointer = windowTitle.toNativeUtf16();
    final hwnd = _findWindowByTitle!(windowTitlePointer);
    calloc.free(windowTitlePointer);

    return hwnd;
  }
}
