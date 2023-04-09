import 'package:flutter/material.dart';

class StreamScreen extends StatefulWidget {
  const StreamScreen({Key? key}) : super(key: key);

  @override
  _StreamScreenState createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  Stream<int> streamNumbers() async* {
    for(int i = 0; i < 10; i++) {
      if(i == 5) {
        throw Exception('i = 5');
      }
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>(
          stream: streamNumbers(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'StreamBuilder',
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
                    Navigator.of(context).pop();
                  },
                  child: Text('To Future Page'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
