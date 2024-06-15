import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pieklo_server_flutter/screens/bt_server_page.dart';
import 'package:pieklo_server_flutter/screens/landing_page.dart';
import 'package:pieklo_server_flutter/screens/tcp_server_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pieklo Server',
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/tcp_server': (context) => TcpServerPage(),
        '/bt_server': (context) => BtServerPage(),
      },
    );
  }
}
