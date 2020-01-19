import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;

import 'drawn_hand.dart';

class GradientClock extends StatefulWidget {
  const GradientClock(this.model);

  final ClockModel model;
  @override
  _GradientClockState createState() => _GradientClockState();
}

class _GradientClockState extends State<GradientClock> {
  DateTime _now = DateTime.now();
  Timer _timer;

  // /// Total distance traveled by a second or a minute hand, each second or minute,
// /// respectively.
  final radiansPerTick = radians(360 / 60);

// /// Total distance traveled by an hour hand, each hour, in radians.
  final radiansPerHour = radians(360 / 12);

  @override
  void initState() {
    super.initState();
    // Set the initial values.
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(milliseconds: 1),
        _updateTime,
      );
    });
  }

  Widget get _hoursHand {
    return DrawnHand(
      color: Colors.white,
      thickness: 5,
      size: 0.65,
      angleRadians:
          _now.hour * radiansPerHour + (_now.minute / 60) * radiansPerHour,
      negativeSize: 0.1,
    );
  }

  Widget get _minutesHand {
    return DrawnHand(
      color: Colors.white,
      thickness: 4,
      size: 0.75,
      angleRadians:
          _now.minute * radiansPerTick + (_now.second / 60) * radiansPerTick,
      negativeSize: 0.2,
    );
  }

  Widget get _secondsHand {
    return DrawnHand(
      color: Colors.green,
      thickness: 3,
      size: 0.98,
      angleRadians: _now.second * radiansPerTick +
          (_now.millisecond / 1000) * radiansPerTick,
      negativeSize: 0.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2.0,
          color: Colors.black,
        ),
        gradient: LinearGradient(
          colors: <Color>[
            Colors.blue[100],
            Colors.blue,
          ],
          transform: GradientRotation(math.pi / 2),
        ),
      ),
      child: Stack(
        children: [
          _hoursHand,
          _minutesHand,
          _secondsHand,
        ],
      ),
    );
  }
}
