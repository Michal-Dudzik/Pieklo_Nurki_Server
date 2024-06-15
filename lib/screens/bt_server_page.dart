import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/providers/providers.dart';

class BtServerPage extends ConsumerStatefulWidget {
  @override
  _BtServerPageState createState() => _BtServerPageState();
}

class _BtServerPageState extends ConsumerState<BtServerPage> {
  bool _isClientConnected = false;
  bool isWindowFound = false;
  // late BtServer _btServer;

  // @override
  // void initState() {
  //   super.initState();
  //   _btServer = BtServer(ref);
  //
  //   _btServer.startServer((clientConnected) {
  //     setState(() {
  //       _isClientConnected = clientConnected;
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _btServer.stopServer();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final isWindowFound = ref.watch(gameWindowStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Server Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client connected: ${_isClientConnected ? "Yes" : "No"}'),
            SizedBox(height: 10),
            Text('Game window found: ${isWindowFound ? "Yes" : "No"}'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
