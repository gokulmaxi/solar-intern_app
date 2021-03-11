import 'package:flutter/cupertino.dart';
import 'package:solar/mqtt/jsonHandler.dart';

class MQTTAppState with ChangeNotifier {
  double _inputVoltage = 0;
  double _outputVoltage = 0;
  double _batteryVoltage = 0;
  double _loadPercentage = 0;
  String _solarStatus = "nil";
  String _mainStatus = "Nil";
  String _batteryStatus = "Float";
  String _inverterStatus = "Off";
  void setData(JsonData jsonString) {
    _inputVoltage = double.parse(jsonString.inputVoltage);
    _outputVoltage = double.parse(jsonString.outputVoltage);
    _batteryVoltage = double.parse(jsonString.batteryVoltage);
    _loadPercentage =
        double.parse(jsonString.loadPercentage.replaceAll(new RegExp('%'), ''));
    _solarStatus = _setSolarStatus(jsonString.solarStatus);
    _mainStatus = _setMainStatus(jsonString.mainStatus);
    _batteryStatus = _setBatteryStatus(jsonString.batteryStatus);
    _inverterStatus = _setSolarStatus(jsonString.inverterStatus);
    notifyListeners();
  }

  double get getInputVoltage => _inputVoltage;
  double get getOutputVoltage => _outputVoltage;
  double get getBatteryVoltage => _batteryVoltage;
  double get getLoadPercentage => _loadPercentage;
  String get getSolarStatus => _solarStatus;
  String get getMainStatus => _mainStatus;
  String get getBatteryStatus => _batteryStatus;
  String get getInverterStatus => _inverterStatus;
}

_setSolarStatus(String param) {
  switch (param) {
    case "1":
      return "Nil";
      break;
    case "2":
      return "Ok";
    default:
  }
}

_setMainStatus(String param) {
  switch (param) {
    case "1":
      return "Nil";
    case "2":
      return "Ok";
      break;
    default:
  }
}

_setBatteryStatus(String param) {
  switch (param) {
    case "1":
      return "Discharge";
      break;
    case "2":
      return "boost";
      break;
    case "3":
      return "Float";
      break;
    default:
  }
}

_setInverterStatus(String param) {
  switch (param) {
    case "1":
      return "Off";
    case "2":
      return "on";
    case "3":
      return "overload";
    case "4":
      return "battery low";

      break;
    default:
  }
}
