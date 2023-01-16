import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Bloc Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Current value => ${state.value}'),
                  Visibility(
                    visible: state is CounterStateInvalidNumber,
                    child: Text('Invalid input: $invalidValue'),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a number here',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // give access to a bloc
                          context
                              .read<CounterBloc>()
                              .add(DecrementEvent(_controller.text));
                        },
                        child: const Text('-'),
                      ),
                      TextButton(
                        onPressed: () {
                          // give access to a bloc
                          context
                              .read<CounterBloc>()
                              .add(IncrementEvent(_controller.text));
                        },
                        child: const Text('+'),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value); // if not able will return null
      if (integer == null) {
        // thanks to emit we are able to pass state outside bloc
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value + integer),
        );
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value); // if not able will return null
      if (integer == null) {
        // thanks to emit we are able to pass state outside bloc
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(
          CounterStateValid(state.value - integer),
        );
      }
    });
  }
}
