import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(MyApp());
}

List<int> numbers = List.generate(22, (index) => index + 1);
List<String> pairs = [];

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _randomint = -1;
  bool _value = false;
  int randompair = -1;
  String _AnimText = " ";
  StreamController<int> controller = StreamController<int>();
  late AnimationController _Animcontroller = AnimationController(
    duration: const Duration(seconds: 7),
    vsync: this,
  );
  late Animation<double> _animation = CurvedAnimation(
    parent: _Animcontroller,
    curve: Interval(0.5, 1, curve: Curves.fastOutSlowIn),
  );

  @override
  void dispose() {
    super.dispose();
    _Animcontroller.dispose();
  }

  void _incrementCounter() {
    setState(() {
      if (_value) {
        print(randompair);
        print(pairs);
        print(pairs.length);
        if (randompair != -1) {
          pairs.removeAt(randompair);
          print(numbers);
        }
        randompair = Fortune.randomInt(0, pairs.length - 1);
        controller.add(randompair);
        var torem = pairs[randompair].split(" ");
        for (String i in torem) {
          numbers.remove(int.parse(i));
        }
        _AnimText = pairs[randompair];
      } else {
        if (_randomint != -1) {
          numbers.removeAt(_randomint);
          print(numbers);
        }
        _randomint = Fortune.randomInt(0, numbers.length - 1);
        print(_randomint);
        controller.add(
          _randomint,
        );
        _AnimText = numbers[_randomint].toString();
      }
      _Animcontroller.reset();
      _Animcontroller.forward();
    });
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Switch(
                    value: _value,
                    onChanged: (bool value) {
                      setState(() {
                        _value = value;
                        print(_value);
                        _Animcontroller.reset();
                        if (value) {
                          if (_randomint != -1) {
                            numbers.removeAt(_randomint);
                            _randomint = -1;
                          }
                          pairs = List.generate(
                              numbers.length ~/ 3,
                              (index) =>
                                  "${numbers[3 * index]} ${numbers[3 * index + 1]} ${numbers[3 * index + 2]}");
                        } else {
                          randompair = -1;
                        }
                      });
                    }),
                Expanded(
                  child: FortuneWheel(
                      selected: controller.stream,
                      items: (_value)
                          ? [
                              for (var it in pairs)
                                FortuneItem(
                                    child: Text(
                                  it,
                                  style: TextStyle(fontSize: 20),
                                ))
                            ]
                          : [
                              for (var it in numbers)
                                FortuneItem(
                                    child: Text(
                                  it.toString(),
                                  style: TextStyle(fontSize: 20),
                                ))
                            ]),
                ),
              ],
            ),
            Center(
              child: ScaleTransition(
                  scale: _animation,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      _AnimText,
                      style: TextStyle(fontSize: 300),
                    ),
                  )),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
