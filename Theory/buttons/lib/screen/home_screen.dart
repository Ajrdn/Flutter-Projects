import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('ButtonStyle'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  if(states.contains(MaterialState.pressed)) {
                    return Colors.green;
                  }
                  return Colors.black;
                }),
                foregroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  if(states.contains(MaterialState.pressed)) {
                    return Colors.white;
                  }
                  return Colors.red;
                }),
                padding: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) {
                  if(states.contains(MaterialState.pressed)) {
                    return const EdgeInsets.all(100.0);
                  }
                  return const EdgeInsets.all(20.0);
                }),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                shadowColor: Colors.green,
                elevation: 10.0,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
                padding: const EdgeInsets.all(32.0),
                side: const BorderSide(
                  color: Colors.black,
                  width: 4.0,
                ),
              ),
              child: const Text('ElevatedButton'),
            ),
            OutlinedButton(
              onPressed: () {},
              child: const Text('OutlinedButton'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.green,
                elevation: 10.0,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('TextButton'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
