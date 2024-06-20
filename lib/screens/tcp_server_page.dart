import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/components/animated_text.dart';
import 'package:pieklo_server_flutter/components/info_dialog.dart';
import 'package:pieklo_server_flutter/providers/providers.dart';
import 'package:pieklo_server_flutter/services/servers/tcp_server.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TcpServerPage extends ConsumerStatefulWidget {
  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends ConsumerState<TcpServerPage>
    with TickerProviderStateMixin {
  String _ipAddress = '0.0.0.0';
  int _port = 5000;
  bool _isClientConnected = false;
  late TcpServer _tcpServer;

  late AnimationController _line1Controller;
  late AnimationController _line2Controller;
  late AnimationController _line3Controller;
  late AnimationController _line4Controller;
  late AnimationController _qrController;

  late Animation<double> _line1Animation;
  late Animation<double> _line2Animation;
  late Animation<double> _line3Animation;
  late Animation<double> _line4Animation;
  late Animation<double> _qrAnimation;

  @override
  void initState() {
    super.initState();
    _tcpServer = TcpServer(ref);
    _startServer();

    _line1Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _line2Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _line3Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _line4Controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _qrController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _line1Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _line1Controller, curve: Curves.linear),
    );

    _line2Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _line2Controller, curve: Curves.linear),
    );

    _line3Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _line3Controller, curve: Curves.linear),
    );

    _line4Animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _line4Controller, curve: Curves.linear),
    );

    _qrAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _qrController, curve: Curves.linear),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _line1Controller.forward().orCancel;
    await _line2Controller.forward().orCancel;
    await _line3Controller.forward().orCancel;
    await _line4Controller.forward().orCancel;
    _qrController.forward();
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
    _line1Controller.dispose();
    _line2Controller.dispose();
    _line3Controller.dispose();
    _line4Controller.dispose();
    _qrController.dispose();
    super.dispose();
  }

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const InfoDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final serverAddress = '$_ipAddress;$_port';
    final isWindowFound = ref.watch(gameWindowStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xff000000),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'PiekloServer v1.0 - Experimental Connection',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 16,
            fontFamily: 'Lucida Console',
          ),
        ),
        toolbarHeight: 40,
        iconTheme: const IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showInstructionsDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedText(
              text: 'Server running on: $_ipAddress:$_port',
              animation: _line1Animation,
            ),
            const SizedBox(height: 10),
            AnimatedText(
              text: 'Client connected: ${_isClientConnected ? "Yes" : "No"}',
              animation: _line2Animation,
            ),
            const SizedBox(height: 10),
            AnimatedText(
              text: 'Game window found: ${isWindowFound ? "Yes" : "No"}',
              animation: _line3Animation,
            ),
            const SizedBox(height: 10),
            // AnimatedText(
            //   text:
            //       'Scan QR code below with the Pieklo Nurki™ app to connect to the server or enter the address manually',
            //   animation: _line4Animation,
            // ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _qrAnimation,
              child: QrImageView(
                data: serverAddress,
                size: 300.0,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
