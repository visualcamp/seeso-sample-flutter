import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seeso_sample_flutter/widget/camera_handle_widget.dart';
import 'package:seeso_sample_flutter/widget/initialized_widget.dart';
import 'package:seeso_sample_flutter/widget/initializing_widget.dart';
import 'package:seeso_sample_flutter/widget/tracking_status_widget.dart';

import 'provider/seeso_provider.dart';
import 'widget/calibration_widget.dart';
import 'widget/gaze_point_widget.dart';
import 'widget/initialized_fail_dialog_widget.dart';
import 'widget/loading_widget.dart';
import 'widget/title_widget.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SeeSoState state = ref.watch<SeeSoProvider>(seesoProvider).state;
    bool isCalibrating = ref.watch<SeeSoProvider>(seesoProvider).isCalibrating;
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Container(
              color: Colors.white10,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const TitleWidget(),
                      if (state == SeeSoState.first) const CameraHandleWidget(),
                      if (state == SeeSoState.none) const InitializingWidget(),
                      if (state == SeeSoState.initialized)
                        const InitializedWidget(),
                      if (state == SeeSoState.tracking)
                        const TrackingModeWidget(),
                    ]),
              )),
        ),
        if (state == SeeSoState.tracking && !isCalibrating)
          const GazePointWidget(),
        if (state == SeeSoState.initializing) const LoadingCircleWidget(),
        if (isCalibrating) const CalibrationWidget(),
        if (ref.watch<SeeSoProvider>(seesoProvider).failedReason != null)
          const InitializedFailDialog()
      ],
    );
  }
}
