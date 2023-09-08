import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light/light.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import 'canvas_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double value = 0.0;
  Timer? _timer;
  bool inSun = false;

  void changeValue() {
    setState(() {
      inSun = true;
    });
    const duration = Duration(seconds: 20);
    double step = 1 / (duration.inMilliseconds / 100);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      print(_timer!.tick);
      if (value >= 1 || _timer!.tick == 200) {
        _timer?.cancel();
        setState(() {
          value = 1;
        });
      } else {
        setState(() {
          value += step;
        });
      }
    });
  }

  Light light = Light();
  String luxString = 'Sem Luz';
  StreamSubscription? _subscription;

  @override
  void initState() {
    startListening();
    super.initState();
  }

  void onData(int luxValue) async {
    debugPrint("Lux value: $luxValue");
    setState(() {
      luxString = luxValue.toString();
    });

    if (luxValue > 2000) {
      if (inSun == false) {
        changeValue();
      }
    } else {
      _timer!.cancel();
      setState(() {
        inSun = false;
      });
    }
  }

  void startListening() {
    try {
      _subscription = light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquid Progress Indicator v2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.center, children: [
              Icon(Icons.wb_sunny_rounded,
                  size: 350, color: Colors.yellow.withOpacity(value)),
              LiquidCustomProgressIndicator(
                shapePath: CanvasController.buildSunPath(),
                direction: Axis.vertical,
                value: value,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation(Colors.yellow),
              ),
            ]),
            // O ícone
            ElevatedButton(
              onPressed: changeValue,
              child: const Text('Progressão'),
            ),

            Text('''DEBUG
                $luxString
                ${_timer?.tick}''')
          ],
        ),
      ),
    );
  }
}
