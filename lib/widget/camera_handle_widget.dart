import 'package:flutter/material.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraHandleWidget extends ConsumerWidget {
  const CameraHandleWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        const Text(
          'We must have cmaera permission!',
          style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              decoration: TextDecoration.none),
        ),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () => {
                    ref
                        .read<SeeSoProvider>(seesoProvider)
                        .requestCameraPermission(),
                  },
              child: const Text(
                'Click here to request cmaera authorization',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
