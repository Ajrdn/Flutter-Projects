import 'package:flutter/material.dart';
import 'package:hive_database/const.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveScreen2 extends StatelessWidget {
  const HiveScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HiveScreen2'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(
            valueListenable: Hive.box(testBox).listenable(),
            builder: (context, box, widget) {
              return Column(
                children: box.values.map((value) => Text(value.toString())).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
