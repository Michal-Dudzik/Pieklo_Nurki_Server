import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/providers/providers.dart';
import 'package:pieklo_server_flutter/services/servers/tcp_server.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class TcpServerPage extends ConsumerStatefulWidget {
  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends ConsumerState<TcpServerPage> {
  String _ipAddress = '0.0.0.0';
  int _port = 5000;
  bool _isClientConnected = false;
  late TcpServer _tcpServer;

  @override
  void initState() {
    super.initState();
    _tcpServer = TcpServer(ref);
    _startServer();
  }

  void _startServer() {
    _tcpServer.startServer((ip, port) {
      setState(() {
        _ipAddress = ip;
        _port = port;
      });
    }, (clientConnected) {
      setState(() {
        _isClientConnected = clientConnected;
      });
    });
  }

  @override
  void dispose() {
    _tcpServer.stopServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverAddress = '$_ipAddress;$_port';
    final isWindowFound = ref.watch(gameWindowStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Server Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Server running on $_ipAddress:$_port'),
            SizedBox(height: 10),
            Text('Client connected: ${_isClientConnected ? "Yes" : "No"}'),
            SizedBox(height: 10),
            Text('Game window found: ${isWindowFound ? "Yes" : "No"}'),
            SizedBox(height: 20),
            Center(
              child: PrettyQr(
                data: serverAddress,
                size: 200,
                roundEdges: true,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Scan this QR code with a mobile device to connect to the server',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
