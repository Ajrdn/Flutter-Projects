import 'package:flutter/material.dart';
import 'package:hive_database/const.dart';
import 'package:hive_database/screen/hive_screen2.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveScreen1 extends StatefulWidget {
  const HiveScreen1({Key? key}) : super(key: key);

  @override
  State<HiveScreen1> createState() => _HiveScreen1State();
}

class _HiveScreen1State extends State<HiveScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HiveScreen1'),
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
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              print('keys : ${box.keys}');
              print('values : ${box.values}');
            },
            child: Text('박스 프린트하기!'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              box.put(1000, '새로운 데이터!!!');
            },
            child: Text('데이터 넣기!'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              print(box.get(2));
            },
            child: Text('특정 값 가져오기!'),
          ),
          ElevatedButton(
            onPressed: () {
              final box = Hive.box(testBox);
              print(box.deleteAt(2));
            },
            child: Text('삭제하기!'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => HiveScreen2()));
            },
            child: Text('다음화면!'),
          ),
        ],
      ),
    );
  }
}
