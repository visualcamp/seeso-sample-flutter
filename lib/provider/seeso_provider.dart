import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seeso_flutter/event/calibration_info.dart';
import 'package:seeso_flutter/event/gaze_info.dart';
import 'package:seeso_flutter/event/status_info.dart';
import 'package:seeso_flutter/event/user_status_info.dart';
import 'package:seeso_flutter/one_euro_filter_manager.dart';
import 'package:seeso_flutter/seeso.dart';
import 'package:seeso_flutter/seeso_initialized_result.dart';
import 'package:seeso_flutter/seeso_plugin_constants.dart';

final seesoProvider = ChangeNotifierProvider<SeeSoProvider>((ref) {
  return SeeSoProvider();
});

//todo Please enter the key value for development issued by the SeeSo.io
const String licenseKey = "Input your license key.";

enum SeeSoState {
  first,
  none,
  initializing,
  initialized,
  tracking,
}

class SeeSoProvider with ChangeNotifier {
  final _seeso = SeeSo();
  bool hasCameraPermission = false;
  bool useUserStatus = false;
  bool _useFilter = false;

  GazeInfo? gazeInfo;

  Point nextPoint = const Point(0, 0);

  double progress = 0;

  CalibrationMode calibrationMode = CalibrationMode.FIVE;

  SeeSoState state = SeeSoState.first;
  String? failedReason;
  List<double>? calibrationData;
  bool isCalibrating = false;

  OneEuroFilterManager _filterManager = OneEuroFilterManager(count: 2);

  UserStatusInfo? attentionInfo, blinkInfo, drowsinessInfo;

  SeeSoProvider() {
    checkCameraPermission();
  }

  void checkCameraPermission() async {
    hasCameraPermission = await _seeso.checkCameraPermission();
    if (hasCameraPermission) {
      state = SeeSoState.none;
    }
    notifyListeners();
  }

  void requestCameraPermission() async {
    hasCameraPermission = await _seeso.requestCameraPermission();
    if (hasCameraPermission) {
      state = SeeSoState.none;
    }
    notifyListeners();
  }

  void initGazeTracker(
      bool useAttention, bool useBlink, bool useDrowsiness) async {
    state = SeeSoState.initializing;
    notifyListeners();
    if (useAttention || useBlink || useDrowsiness) {
      useUserStatus = true;
    } else {
      useUserStatus = false;
    }
    try {
      InitializedResult? initResult = await _seeso.initGazeTracker(
          licenseKey: licenseKey,
          useAttention: useAttention,
          useBlink: useBlink,
          useDrowsiness: useDrowsiness);

      if (initResult != null && initResult.result == true) {
        state = SeeSoState.initialized;
        failedReason = null;
        if (useUserStatus) {
          _seeso.setAttentionInterval(10);
        }
        setListener();
      } else {
        state = SeeSoState.none;
        failedReason =
            initResult != null ? initResult.message : "Unknown error";
      }
      notifyListeners();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed seeso's initGazeTracker call : ${e.message}");
      }
      state = SeeSoState.none;
      failedReason = e.message;
      notifyListeners();
    }
  }

  void deinitGazeTracker() {
    _seeso.deinitGazeTracker();
    useUserStatus = false;
    gazeInfo = null;
    nextPoint = const Point(0, 0);
    progress = 0;
    failedReason = null;
    attentionInfo = null;
    blinkInfo = null;
    drowsinessInfo = null;
    state = SeeSoState.none;
    notifyListeners();
  }

  void startTracking() {
    try {
      _seeso.startTracking();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed seeso's startTracking call : ${e.message}");
      }
      failedReason = e.message;
      notifyListeners();
    }
  }

  void stopTracking() {
    try {
      _seeso.stopTracking();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed seeso's stopTracking call : ${e.message}");
      }
      failedReason = e.message;
      notifyListeners();
    }
  }

  void startCalibration(CalibrationMode calibrationMode) async {
    if (state == SeeSoState.tracking) {
      try {
        _seeso.startCalibration(calibrationMode);
        checkCalibrating();
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print("failed seeso's startCalibration call : ${e.message}");
        }
        failedReason = e.message;
        notifyListeners();
      }
    } else {
      failedReason = "SeeSo Not tracking State";
      notifyListeners();
    }
  }

  void checkCalibrating() async {
    try {
      isCalibrating = await _seeso.isCalibrating() ?? false;
      notifyListeners();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed seeso's isCalibration call : ${e.message}");
      }
      failedReason = e.message;
      notifyListeners();
    }
  }

  void stopCalibration() {
    try {
      _seeso.stopCalibration();
      isCalibrating = false;
      notifyListeners();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed seeso's stopCalibration call : ${e.message}");
      }
      failedReason = e.message;
      notifyListeners();
    }
  }

  void startCollectSamples() {
    try {
      Timer(const Duration(milliseconds: 500), () {
        _seeso.startCollectSamples();
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("failed seeso's startCollectSamples call : ${e.message}");
      }
      failedReason = e.message;
      notifyListeners();
    }
  }

  void setListener() {
    _seeso.getGazeEvent().listen((event) {
      GazeInfo gazeInfo = GazeInfo(event);
      this.gazeInfo = gazeInfo;
      if (_useFilter) {
        bool isFiltered = _filterManager
            .filterValues(gazeInfo.timestamp, [gazeInfo.x, gazeInfo.y]);
        if (isFiltered) {
          this.gazeInfo?.setGaze(_filterManager.getFilteredValues()[0],
              _filterManager.getFilteredValues()[1]);
        }
      }
      notifyListeners();
    });

    _seeso.getStatusEvent().listen((event) {
      StatusInfo statusInfo = StatusInfo(event);
      if (statusInfo.type == StatusType.START) {
        state = SeeSoState.tracking;
      } else {
        state = SeeSoState.initialized;
      }
      notifyListeners();
    });

    _seeso.getCalibrationEvent().listen((event) {
      CalibrationInfo calibrationInfo = CalibrationInfo(event);
      if (calibrationInfo.type == CalibrationType.CALIBRATION_NEXT_XY) {
        if (calibrationInfo.nextX != null && calibrationInfo.nextY != null) {
          nextPoint = Point(calibrationInfo.nextX!, calibrationInfo.nextY!);
          progress = 0;
          startCollectSamples();
        } else {
          isCalibrating = false;
        }
      } else if (calibrationInfo.type == CalibrationType.CALIBRATION_PROGRESS) {
        progress = calibrationInfo.progress!;
      } else {
        calibrationData = calibrationInfo.calibrationData;
        isCalibrating = false;
      }
      notifyListeners();
    });

    _seeso.getUserStatusEvent().listen((event) {
      UserStatusInfo userStatusInfo = UserStatusInfo(event);
      if (userStatusInfo.type == UserStatusEventType.ATTENTION) {
        print("attention data : ${userStatusInfo.attentionScore}");
        attentionInfo = userStatusInfo;
      } else if (userStatusInfo.type == UserStatusEventType.BLINK) {
        blinkInfo = userStatusInfo;
      } else {
        drowsinessInfo = userStatusInfo;
      }
      notifyListeners();
    });
  }

  clearFailedReason() {
    deinitGazeTracker();
    failedReason = null;
    notifyListeners();
  }

  void useGazeFilter(bool useFilter) {
    _useFilter = useFilter;
  }
}
