import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff1e1e1e),
      title: const Text(
        'Instructions',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              '1. Ensure your device is connected to the same network as the server.',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '2. Make sure the Helldivers 2 is running on the pc.',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '3. You need to make sure to bind the stratagems arrows to the keyboard arrows.',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '4. Open the Pieklo Nurki™ app and scan the QR code.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              'Warning:',
              style: TextStyle(
                  color: const Color(0xffffe80a), fontWeight: FontWeight.bold),
            ),
            Text(
              'This connection to the game is an experimental feature and may not work as expected.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close',
              style: TextStyle(
                color: const Color(0xffffe80a),
              )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
