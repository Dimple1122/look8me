import 'package:flutter/material.dart';

class NetworkNotAvailable extends StatelessWidget {
  const NetworkNotAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            // Icon(Icons.signal)
          ],
        ),
      ),
    );
  }
}
