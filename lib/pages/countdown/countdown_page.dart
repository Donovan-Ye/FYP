import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_yzj/bloc/countdown/ticker.dart';
import 'package:fyp_yzj/bloc/countdown/timer_bloc.dart';
import 'package:fyp_yzj/bloc/countdown/timer_event.dart';
import 'package:fyp_yzj/bloc/countdown/timer_state.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_page.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_connecting_page.dart';
import 'package:get/get.dart';

class CountdownPage extends StatelessWidget {
  final int hour;
  final int minute;
  final int second;

  const CountdownPage({Key key, this.hour, this.minute, this.second})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int secondSum = hour * 60 * 60 + minute * 60 + second;
    return MaterialApp(
      home: BlocProvider(
        create: (context) => TimerBloc(secondSum, ticker: Ticker()),
        child: Timer(
          duration: secondSum,
        ),
      ),
    );
  }
}

class Timer extends StatelessWidget {
  final int duration;

  static const TextStyle timerTextStyle = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  const Timer({Key key, this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TimerBloc>(context)
        .add(TimerStarted(duration: this.duration));

    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      final String hoursStr =
                          ((state.duration / (60 * 60)) % 60)
                              .floor()
                              .toString()
                              .padLeft(2, '0');
                      final String minutesStr = ((state.duration / 60) % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      final String secondsStr = (state.duration % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      return Text(
                        '$hoursStr:$minutesStr:$secondsStr',
                        style: Timer.timerTextStyle,
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<TimerBloc, TimerState>(
                buildWhen: (previousState, currentState) =>
                    currentState.runtimeType != previousState.runtimeType,
                builder: (context, state) => Actions(),
              ),
              BlocListener<TimerBloc, TimerState>(
                listener: (context, state) {
                  if (BlocProvider.of<TimerBloc>(context).state
                      is TimerRunComplete) {
                    Get.toNamed(FakeCallPage.routeName);
                  }
                },
                child: Container(width: 0.0, height: 0.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    TimerBloc timerBloc,
  }) {
    final TimerState currentState = timerBloc.state;
    if (currentState is TimerInitial) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () =>
              timerBloc.add(TimerStarted(duration: currentState.duration)),
        ),
      ];
    }
    if (currentState is TimerRunInProgress) {
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => timerBloc.add(TimerPaused()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(TimerReset()),
        ),
      ];
    }
    if (currentState is TimerRunPause) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.add(TimerResumed()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(TimerReset()),
        ),
      ];
    }
    if (currentState is TimerRunComplete) {
      // Get.toNamed(FakeCallConnectingPage.routeName);
      return [];
    }
    return [];
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(184, 189, 245, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(172, 182, 219, 0.7)
          ],
          [
            Color.fromRGBO(72, 73, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(190, 238, 246, 0.7)
          ],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [0.03, 0.01, 0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 25,
      backgroundColor: Colors.blue[50],
    );
  }
}
