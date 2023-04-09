import 'package:flutter/material.dart';
import 'package:hive_database/screen/hive_screen1.dart';
import 'package:hive_database/const.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox(testBox);

  runApp(
    MaterialApp(
      home: HiveScreen1(),
    ),
  );
}
