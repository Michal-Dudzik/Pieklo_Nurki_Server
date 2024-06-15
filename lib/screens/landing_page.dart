import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pieklo Server'),
        centerTitle: true,
      ),
      body: Center(
        child: OverflowBar(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bt_server');
              },
              child: Text('Connect via Bluetooth'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tcp_server');
              },
              child: Text('Connect via TCP Server'),
            ),
          ],
        ),
      ),
    );
  }
}
