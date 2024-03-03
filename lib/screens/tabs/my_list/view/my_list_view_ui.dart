import 'package:flutter/material.dart';

class MyList extends StatelessWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('MyList', style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Center(child: Text('MyList', style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
