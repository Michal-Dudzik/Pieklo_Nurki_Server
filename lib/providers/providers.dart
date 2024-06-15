import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/services/helpers/game_window_finder.dart';
import 'package:pieklo_server_flutter/services/helpers/key_press_sender.dart';

// Provider for GameWindowFinder
final gameWindowFinderProvider = Provider<GameWindowFinder>((ref) {
  return GameWindowFinder();
});

// Provider for KeyPressSender
final keyPressSenderProvider = Provider<KeyPressSender>((ref) {
  return KeyPressSender();
});

// StateNotifier to manage the game window state
class GameWindowStateNotifier extends StateNotifier<bool> {
  final GameWindowFinder _gameWindowFinder;

  GameWindowStateNotifier(this._gameWindowFinder) : super(false);

  void findGameWindow(String windowTitle) {
    final windowFound = _gameWindowFinder.findGameWindow(windowTitle);
    state = windowFound != 0;
  }
}

// Provider for GameWindowStateNotifier
final gameWindowStateProvider =
    StateNotifierProvider<GameWindowStateNotifier, bool>((ref) {
  final gameWindowFinder = ref.read(gameWindowFinderProvider);
  return GameWindowStateNotifier(gameWindowFinder);
});
