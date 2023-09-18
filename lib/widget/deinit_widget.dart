import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

class DeinitModeWidget extends ConsumerWidget {
  const DeinitModeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: <Widget>[
      const Text('GazeTracker is activated.',
          style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              decoration: TextDecoration.none)),
      Container(
        height: 10,
      ),
      Container(
        width: double.maxFinite,
        color: Colors.white12,
        child: TextButton(
            onPressed: () => {
                  ref.read<SeeSoProvider>(seesoProvider).deinitGazeTracker(),
                },
            child: const Text(
              'Stop GazeTracker',
              style: TextStyle(color: Colors.white),
            )),
      ),
      Container(
        width: double.maxFinite,
        height: 1,
        color: Colors.white24,
      ),
      const Text(
          'You can init GazeTracker With UserOption! \n (need to restart GazeTracker)',
          style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              decoration: TextDecoration.none)),
    ]);
  }
}
