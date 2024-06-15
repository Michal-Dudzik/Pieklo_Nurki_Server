import 'package:flutter/material.dart';
import 'package:pieklo_server_flutter/services/bt_server.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class BtServerPage extends StatefulWidget {
  @override
  _BtServerPageState createState() => _BtServerPageState();
}

class _BtServerPageState extends State<BtServerPage> {
  String _serverStatus = 'Not connected';
  bool _isClientConnected = false;
  BluetoothServer? _bluetoothServer;

  @override
  void initState() {
    super.initState();
    _initializeBluetoothServer();
  }

  void _initializeBluetoothServer() async {
    // Initialize Bluetooth server
    final server = await BluetoothServer.create();
    setState(() {
      _bluetoothServer =
          BluetoothServer(_onDataReceived, server.characteristic, server);
      _serverStatus = 'Listening for connections';
    });
  }

  void _onDataReceived(String command) {
    setState(() {
      // Handle received command
      _bluetoothServer?.sendKeyPress(command);
    });
  }

  @override
  void dispose() {
    _bluetoothServer?.closeServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Server Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Server Status: $_serverStatus'),
            SizedBox(height: 20),
            Text('Client connected: ${_isClientConnected ? "Yes" : "No"}'),
            SizedBox(height: 20),
            Center(
              child: PrettyQr(
                data: _bluetoothServer?.bluetoothAddress ?? 'No address',
                size: 200,
                roundEdges: true,
              ),
            ),
            SizedBox(height: 20),
            Center(
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
