import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/providers/providers.dart';

import '../constants.dart';

void handleCommand(WidgetRef ref, String message) {
  final keyPressSender = ref.read(keyPressSenderProvider);

  switch (message) {
    case 'UP':
      keyPressSender.handleKeyPress(ref, VK_UP);
      break;
    case 'DOWN':
      keyPressSender.handleKeyPress(ref, VK_DOWN);
      break;
    case 'LEFT':
      keyPressSender.handleKeyPress(ref, VK_LEFT);
      break;
    case 'RIGHT':
      keyPressSender.handleKeyPress(ref, VK_RIGHT);
      break;
    case 'TRUE':
      keyPressSender.handleKeyPress(ref, VK_CONTROL, keyDown: true);
      break;
    case 'FALSE':
      keyPressSender.handleKeyPress(ref, VK_CONTROL, keyDown: false);
      break;
    default:
      print('Unknown command: $message');
  }
}
