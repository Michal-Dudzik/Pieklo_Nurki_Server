import 'package:flutter/material.dart';
import 'package:pieklo_server_flutter/services/game_window_finder.dart';
import 'package:pieklo_server_flutter/services/tcp_server.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class TcpServerPage extends StatefulWidget {
  @override
  _TcpServerPageState createState() => _TcpServerPageState();
}

class _TcpServerPageState extends State<TcpServerPage> {
  String _ipAddress = '0.0.0.0';
  int _port = 5000;
  bool _isClientConnected = false;
  bool _isWindowFound = false;
  late GameWindowFinder _gameWindowFinder;

  @override
  void initState() {
    super.initState();
    _gameWindowFinder = GameWindowFinder();

    startServer((ip, port) {
      setState(() {
        _ipAddress = ip;
        _port = port;
      });
    }, (clientConnected) {
      setState(() {
        _isClientConnected = clientConnected;
        if (_isClientConnected) {
          findGameWindow();
        } else {
          setState(() {
            _isWindowFound = false;
          });
        }
      });
    });
  }

  void findGameWindow() {
    final windowTitle = 'HELLDIVERS™ 2';
    final windowFound = _gameWindowFinder.findGameWindow(windowTitle);

    if (windowFound != 0) {
      setState(() {
        _isWindowFound = true;
      });
    }
  }

  @override
  void dispose() {
    stopServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverAddress = '$_ipAddress:$_port';
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
            Text('Game window found: ${_isWindowFound ? "Yes" : "No"}'),
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
