import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_yzj/bloc/countdown/ticker.dart';
import 'package:fyp_yzj/bloc/countdown/timer_bloc.dart';
import 'package:fyp_yzj/bloc/countdown/timer_event.dart';
import 'package:fyp_yzj/bloc/countdown/timer_state.dart';
import 'package:fyp_yzj/pages/fakeCall/fake_call_page.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

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
        child: _Timer(
          duration: secondSum,
        ),
      ),
    );
  }
}

class _Timer extends StatelessWidget {
  final int duration;

  static const TextStyle timerTextStyle =
      TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white);

  const _Timer({Key key, this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TimerBloc>(context)
        .add(TimerStarted(duration: this.duration));

    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        style: _Timer.timerTextStyle,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 150,
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
          backgroundColor: Color(0xff212121),
          child: Icon(
            Icons.play_arrow,
            size: 30,
            color: Color(0xff1561CD),
          ),
          onPressed: () =>
              timerBloc.add(TimerStarted(duration: currentState.duration)),
        ),
      ];
    }
    if (currentState is TimerRunInProgress) {
      return [
        FloatingActionButton(
          backgroundColor: Color(0xff212121),
          child: Icon(
            Icons.pause,
            size: 30,
            color: Color(0xff1561CD),
          ),
          onPressed: () => timerBloc.add(TimerPaused()),
        ),
        FloatingActionButton(
          backgroundColor: Color(0xff212121),
          child: Icon(
            Icons.replay,
            size: 30,
            color: Color(0xff1561CD),
          ),
          onPressed: () => timerBloc.add(TimerReset()),
        ),
      ];
    }
    if (currentState is TimerRunPause) {
      return [
        FloatingActionButton(
          backgroundColor: Color(0xff212121),
          child: Icon(
            Icons.play_arrow,
            size: 30,
            color: Color(0xff1561CD),
          ),
          onPressed: () => timerBloc.add(TimerResumed()),
        ),
        FloatingActionButton(
          backgroundColor: Color(0xff212121),
          child: Icon(
            Icons.replay,
            size: 30,
            color: Color(0xff1561CD),
          ),
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
    return Container(
      color: Colors.black,
    );
  }
}
