import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/providers/providers.dart';

import '../constants.dart';

void handleCommand(WidgetRef ref, String message) {
  final keyPressSender = ref.read(keyPressSenderProvider);

  switch (message) {
    case 'U':
      keyPressSender.handleKeyPress(ref, VK_UP);
      break;
    case 'D':
      keyPressSender.handleKeyPress(ref, VK_DOWN);
      break;
    case 'L':
      keyPressSender.handleKeyPress(ref, VK_LEFT);
      break;
    case 'R':
      keyPressSender.handleKeyPress(ref, VK_RIGHT);
      break;
    case 'T':
      keyPressSender.handleKeyPress(ref, VK_CONTROL, keyDown: true);
      break;
    case 'F':
      keyPressSender.handleKeyPress(ref, VK_CONTROL, keyDown: false);
      break;
    default:
      print('Unknown command: $message');
  }
}
