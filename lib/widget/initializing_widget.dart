import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

class InitializingWidget extends ConsumerStatefulWidget {
  const InitializingWidget({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitializingWidget();
}

class _InitializingWidget extends ConsumerState<InitializingWidget> {
  bool useUserStatus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('You need to init GazeTracker first',
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
                    ref.read<SeeSoProvider>(seesoProvider).initGazeTracker(
                        useUserStatus, useUserStatus, useUserStatus)
                  },
              child: const Text(
                'Initialize   GazzeTracker',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Container(
          width: double.maxFinite,
          height: 1,
          color: Colors.white24,
        ),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'With User Option',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none),
              ),
              CupertinoSwitch(
                activeColor: Colors.white,
                value: useUserStatus,
                onChanged: (newValue) {
                  setState(() {
                    useUserStatus = newValue;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
