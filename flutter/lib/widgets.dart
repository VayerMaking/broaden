import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: const Text('Popup example'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Hello"),
          ],
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
