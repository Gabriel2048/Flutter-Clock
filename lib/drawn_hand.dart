// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters must not be null.
  const DrawnHand(
      {@required Color color,
      @required this.thickness,
      @required double size,
      @required double angleRadians,
      this.negativeSize})
      : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
          color: color,
          size: size,
          angleRadians: angleRadians,
        );

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;
  final double negativeSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
            handSize: size,
            lineWidth: thickness,
            angleRadians: angleRadians,
            color: color,
            negativeSize: negativeSize,
          ),
        ),
      ),
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class _HandPainter extends CustomPainter {
  _HandPainter(
      {@required this.handSize,
      @required this.lineWidth,
      @required this.angleRadians,
      @required this.color,
      this.negativeSize})
      : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  double negativeSize;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;

    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;

    final destinationOffset = Offset(math.cos(angle), math.sin(angle));
    final length = size.shortestSide * 0.5 * handSize;

    //in case we also have a negative size we will use that increase (towards the opposide direction) the clock's line
    final startingPoint = negativeSize != null
        ? center - destinationOffset * size.shortestSide * 0.5 * negativeSize
        : center;

    final destination = center + destinationOffset * length;

    _drawOutlinedLine(canvas, startingPoint, destination);
  }

  void _drawOutlinedLine(Canvas canvas, Offset start, Offset end) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    final outLineLinePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = lineWidth + 0.3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, outLineLinePaint);
    canvas.drawLine(start, end, linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
