import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

List<int> numbers = List.generate(22, (index) => index + 1)..shuffle();
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
          primarySwatch: Colors.amber,
          textTheme: TextTheme(
            bodyText1: GoogleFonts.spicyRice(fontSize: 50),
            bodyText2: GoogleFonts.spicyRice(fontSize: 300),
          )),
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
  bool _isConfetti = false;

  final player = AudioPlayer();

  StreamController<int> controller = StreamController<int>();
  late AnimationController _Animcontroller = AnimationController(
    duration: const Duration(seconds: 7),
    vsync: this,
  )..addListener(() {
      // print(_Animcontroller.value);
      if (_Animcontroller.value > 0.7 && !_isConfetti) {
        playConfetti();
        player.seekToNext();
      }
      //if (_Animcontroller.isCompleted) player.seekToNext();
    });
  late Animation<double> _animation = CurvedAnimation(
    parent: _Animcontroller,
    curve: Interval(0.5, 1, curve: Curves.fastOutSlowIn),
  );
  late ConfettiController _confettiControllerRight;
  late ConfettiController _confettiControllerLeft;

  @override
  void initState() {
    super.initState();
    _confettiControllerRight =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiControllerLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    init();
  }

  void init() async {
    var duration =
        await player.setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse('asset:///lib/wheelAudio.mp3')),
      AudioSource.uri(Uri.parse('asset:///lib/popAudio.mp3'))
    ]));
  }

  @override
  void dispose() {
    super.dispose();
    _Animcontroller.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _isConfetti = false;
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

      player.play();
      player.seek(Duration(seconds: 0), index: 0);
      _Animcontroller.reset();
      _Animcontroller.forward();
    });
  }

  Widget myConfettiWidget(ConfettiController controller, double direction) {
    return ConfettiWidget(
      numberOfParticles: 10,
      maxBlastForce: 450,
      confettiController: controller,
      blastDirection: direction,
      shouldLoop: false,
      emissionFrequency: 0.8,
      blastDirectionality: BlastDirectionality.explosive,
      colors: [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ],
    );
  }

  void playConfetti() {
    _isConfetti = true;
    _confettiControllerRight.play();
    _confettiControllerLeft.play();
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
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  'lib/b2.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Opacity(
                      opacity: 0.98,
                      child: FortuneWheel(
                          indicators: [
                            FortuneIndicator(
                                alignment: Alignment.topCenter,
                                child: TriangleIndicator(
                                  color: Colors.black,
                                ))
                          ],

                          //styleStrategy: MyCustomFortuneWheel(),
                          selected: controller.stream,
                          items: (_value)
                              ? [
                                  for (var it in pairs)
                                    FortuneItem(
                                      child: Text(
                                        it,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    )
                                ]
                              : [
                                  for (var it in numbers)
                                    FortuneItem(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 50),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: Text(
                                            it.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ],
                                    ))
                                ]),
                    ),
                  ),
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
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  )),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child:
                    myConfettiWidget(_confettiControllerRight, (5 * pi / 4))),
            Align(
                alignment: Alignment.bottomLeft,
                child: myConfettiWidget(_confettiControllerRight, (-pi / 4)))
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.refresh),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyCustomFortuneWheel extends StyleStrategy {
  @override
  FortuneItemStyle getItemStyle(ThemeData theme, int index, int itemCount) {
    // TODO: implement getItemStyle
    if (index.isEven) {
      return FortuneItemStyle(color: Colors.red);
    } else {
      return FortuneItemStyle(color: Colors.white);
    }
  }
}
