import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

class CalibrationWidget extends ConsumerWidget {
  const CalibrationWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Point nextTarget = ref.watch<SeeSoProvider>(seesoProvider).nextPoint;
    return Container(
        color: const Color.fromARGB(140, 0, 0, 0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Look at the circle!',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.none)),
                SizedBox(
                  height: 80,
                ),
              ],
            )),
            Positioned(
              left: nextTarget.x - 24,
              top: nextTarget.y - 24,
              child: CircularPercentIndicator(
                  radius: 24,
                  lineWidth: 2,
                  animation: false,
                  percent: ref.watch<SeeSoProvider>(seesoProvider).progress,
                  center: Text(
                      '${(ref.watch<SeeSoProvider>(seesoProvider).progress * 100).round()}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0))),
            ),
          ],
        ));
  }
}
