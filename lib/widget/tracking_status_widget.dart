import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_flutter/seeso_plugin_constants.dart';
import 'package:seeso_sample_flutter/provider/seeso_provider.dart';

import 'user_status_widget.dart';
import 'deinit_widget.dart';

class TrackingModeWidget extends ConsumerStatefulWidget {
  const TrackingModeWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TrackingModeWidget();
}

class _TrackingModeWidget extends ConsumerState<TrackingModeWidget> {
  CalibrationMode _mode = CalibrationMode.FIVE;
  bool useFilter = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const DeinitModeWidget(),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('Tracking is On!!',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () =>
                  {ref.read<SeeSoProvider>(seesoProvider).stopTracking()},
              child: const Text(
                'Stop tracking',
                style: TextStyle(color: Colors.white),
              )),
        ),
        Container(
            width: double.maxFinite,
            height: 20,
            color: const Color.fromARGB(0, 0, 0, 0)),
        const Text('And also you can improve accuaracy through calibration',
            style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                decoration: TextDecoration.none)),
        Container(
          width: double.maxFinite,
          color: Colors.white12,
          child: TextButton(
              onPressed: () => {
                    ref
                        .read<SeeSoProvider>(seesoProvider)
                        .startCalibration(_mode)
                  },
              child: Text(
                ref.watch<SeeSoProvider>(seesoProvider).isCalibrating
                    ? 'Calibration started!'
                    : 'Start Calibration',
                style: const TextStyle(color: Colors.white),
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
                'Calibration Type',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none),
              ),
              const SizedBox(
                width: 60,
              ),
              CupertinoSegmentedControl(
                children: const {
                  CalibrationMode.ONE: Text(" ONE_POINT ",
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 10,
                          decoration: TextDecoration.none)),
                  CalibrationMode.FIVE: Text(" FIVE_POINT ",
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 10,
                          decoration: TextDecoration.none)),
                },
                onValueChanged: (newValue) {
                  setState(() {
                    _mode = newValue;
                  });
                },
                groupValue: _mode,
                unselectedColor: Colors.white12,
                selectedColor: Colors.white38,
                pressedColor: Colors.white38,
                borderColor: Colors.white12,
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
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
                const Text("Use Filter",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        decoration: TextDecoration.none)),
                const SizedBox(
                  width: 60,
                ),
                CupertinoSwitch(
                    value: useFilter,
                    onChanged: (newValue) {
                      useFilter = newValue;
                      ref
                          .read<SeeSoProvider>(seesoProvider)
                          .useGazeFilter(useFilter);
                    })
              ],
            )),
        if (ref.watch<SeeSoProvider>(seesoProvider).useUserStatus)
          const UserSatatusWidget(),
      ],
    );
  }
}
