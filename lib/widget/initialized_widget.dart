import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

import 'deinit_widget.dart';

class InitializedWidget extends ConsumerWidget {
  const InitializedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        const DeinitModeWidget(),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('Now You can track you gaze!',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () =>
                  {ref.read<SeeSoProvider>(seesoProvider).startTracking()},
              child: const Text(
                'Start Tracking',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
