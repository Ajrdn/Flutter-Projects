import 'dart:math';
import 'package:flutter/material.dart';
import 'package:future_and_stream_builder/screen/stream_screen.dart';

class FutureScreen extends StatefulWidget {
  const FutureScreen({Key? key}) : super(key: key);

  @override
  _FutureScreenState createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    return random.nextInt(100);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<int>(
          future: getNumber(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'FutureBuilder',
                        style: textStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        'ConnectionState : ${snapshot.connectionState}',
                        style: textStyle,
                      ),
                      Text(
                        'Data : ${snapshot.data}',
                      ),
                      Text(
                        'Error : ${snapshot.error}',
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text('setState'),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => StreamScreen()),
                    );
                  },
                  child: Text('To Stream Page'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
