import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_flutter/event/gaze_info.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

class GazePointWidget extends ConsumerWidget {
  static const circleSize = 20.0;

  const GazePointWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GazeInfo? gazeInfo = ref.watch<SeeSoProvider>(seesoProvider).gazeInfo;
    double x = 0, y = 0;
    if (gazeInfo != null && gazeInfo.trackingState == TrackingState.SUCCESS) {
      x = gazeInfo.x;
      y = gazeInfo.y;
    }
    return Positioned(
        //todo gazeInfo.x
        left: x - circleSize / 2.0,
        // todo gazeInfo.y
        top: y - circleSize / 2.0,
        child: Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
                color: Colors.red, shape: BoxShape.circle)));
  }
}
