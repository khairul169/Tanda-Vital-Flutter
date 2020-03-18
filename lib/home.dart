import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dokumentasi Tanda Vital'),
      ),
      body: Container(
        child: Text('Hello world!', style: TextStyle(fontSize: 24),),
        padding: EdgeInsets.all(16),
        alignment: Alignment.center
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          debugPrint("Test!");
        },
      ),
    );
  }
}
