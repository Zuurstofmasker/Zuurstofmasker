import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:typed_data';

import 'package:zuurstofmasker/Helpers/fileHelpers.dart';
import 'package:zuurstofmasker/Helpers/jsonHelpers.dart';

void main() async {
  readFromSerialPort('COM2', (data) {
    print('Data Length: ${data.length}');

    if (data.length == 0) return;
    print("Data: ${data[0]}");
  });

  Uint8List data = Uint8List(1);
  data[0] = 23;
  writeToSerialPort('COM1', data);
  print(jsonToList('["Test", "Test2"]'));

  String path = 'assets/file.txt';

  print(await stringFromFile(path));
  await stringToFile(path, 'Updated data');
  print(await stringFromFile(path));
  await stringToFile('assets/newFile.txt', 'New data');

  runApp(const MyApp());
}

void readFromSerialPort(String name, Function(Uint8List data) onData) {
  SerialPort port = SerialPort(name);
  port.openRead();
  SerialPortReader reader = SerialPortReader(port);
  reader.stream.listen((event) {
    onData(event);
  });
}

void writeToSerialPort(String name, Uint8List data) {
  SerialPort port = SerialPort(name);
  port.openWrite();
  port.write(data);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Opvang'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  List<FlSpot> chartData = [FlSpot(0, 60)];
  void startUpdateChart() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        chartData.add(FlSpot(chartData.last.x + 40, chartData.last.y + 2));
      });
    });
  }

  List<FlSpot> randomSpots(
    int xMin,
    int xMax,
    int yMin,
    int yMax,
    int xChange,
  ) {
    final List<FlSpot> spots = [];
    int currentX = xMin;

    for (int i = 0; i <= ((xMax - xMin) / xChange); i++) {
      spots.add(
        FlSpot(
          currentX.toDouble(),
          Random().nextInt((yMax - yMin)).toDouble() + yMin,
        ),
      );
      currentX += xChange;
    }

    return spots;
  }

  @override
  void initState() {
    startUpdateChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.grey.withAlpha(100),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leadingWidth: 250,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'About',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blueAccent,
              ),
            ),
          )
        ],
        leading: Container(
          height: double.infinity,
          color: Colors.blueGrey,
          width: 550,
          child: const Center(
            child: Text(
              'Add logo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.blue,
            width: 250,
            child: const Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Button(
                        text: 'Opvang',
                        icon: Icons.home,
                        selected: true,
                      ),
                      SizedBox(height: 10),
                      Button(
                        text: 'Geschiedenis',
                        icon: Icons.add,
                      ),
                      SizedBox(height: 10),
                      Button(
                        text: 'Instellingen',
                        icon: Icons.list,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                //
                // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                // action in the IDE, or press "p" in the console), to see the
                // wireframe for each widget.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 50),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'You have pushed the button this many times:',
                        ),
                        Text(
                          '$_counter',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Chart(
                    chartData: chartData,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 25),
                  Chart(
                    chartData: randomSpots(0, 400, 60, 100, 10),
                    color: Colors.red,
                  ),
                  const SizedBox(height: 25),
                  Chart(
                    chartData: randomSpots(0, 400, 60, 100, 10),
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Chart extends StatelessWidget {
  const Chart({super.key, required this.chartData, required this.color});

  final List<FlSpot> chartData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        chartRendererKey: GlobalKey(),
        LineChartData(
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
          clipData: const FlClipData.all(),
          lineBarsData: [
            LineChartBarData(
              belowBarData: BarAreaData(
                show: true,
                color: color.withAlpha(100),
              ),
              isCurved: true,
              spots: chartData,
              color: color,
            )
          ],
          minY: 60,
          maxX: 400,
          maxY: 100,
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;
  const Button({
    super.key,
    required this.icon,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        iconColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
        )),
        backgroundColor: MaterialStateProperty.all(
          selected ? Colors.white.withAlpha(50) : Colors.blue,
        ),
      ),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 15,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
