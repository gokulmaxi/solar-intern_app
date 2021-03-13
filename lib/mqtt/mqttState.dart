import 'package:flutter/cupertino.dart';
import 'package:solar/mqtt/jsonHandler.dart';

class MQTTAppState with ChangeNotifier {
  double _inputVoltage = 0;
  double _outputVoltage = 0;
  double _batteryVoltage = 0;
  double _loadPercentage = 0;
  double _loadPower = 0;
  double _loadCurrent = 0;
  double _backupHours = 0;
  String _solarStatus = "nil";
  String _mainStatus = "Nil";
  String _batteryStatus = "Float";
  String _inverterStatus = "Off";
  bool _criticalLoad = true;
  bool _inverter = false;
  bool _nonCriticalLoad = false;
  void setData(JsonData jsonString) {
    _inputVoltage = double.parse(jsonString.inputVoltage);
    _outputVoltage = double.parse(jsonString.outputVoltage);
    _batteryVoltage = double.parse(jsonString.batteryVoltage);
    _loadPercentage =
        double.parse(jsonString.loadPercentage.replaceAll(new RegExp('%'), ''));
    _solarStatus = _setSolarStatus(jsonString.solarStatus);
    _mainStatus = _setMainStatus(jsonString.mainStatus);
    _batteryStatus = _setBatteryStatus(jsonString.batteryStatus);
    _inverterStatus = _setInverterStatus(jsonString.inverterStatus);
    _inverter = _setInverterBoolStatus(jsonString.inverterStatus);
    _loadPower = _setLoadpower(
        jsonString.loadPercentage.replaceAll(new RegExp('%'), ''));
    _loadCurrent = _setLoadCurrent(
        jsonString.loadPercentage.replaceAll(new RegExp('%'), ''),
        jsonString.batteryVoltage);
    _backupHours = _setBackUpHours(
        jsonString.loadPercentage.replaceAll(new RegExp('%'), ''),
        jsonString.batteryVoltage);
    _criticalLoad = jsonString.critical;
    _nonCriticalLoad = jsonString.nonCritical;
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
  bool get getInverterBoolStatus => _inverter;
  bool get getCriticalLoadStatus => _criticalLoad;
  bool get getNonCriticalLoadStatus => _nonCriticalLoad;
  double get getLoadPower => _loadPower;
  double get getLoadCurrent => _loadCurrent;
  double get getBackupHour => _backupHours;
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

_setInverterBoolStatus(String param) {
  switch (param) {
    case "1":
      return false;
    case "2":
      return true;
    case "3":
      return true;
    case "4":
      return true;

      break;
    default:
  }
}

_setLoadpower(String load) {
  double loadDouble = double.parse(load);
  return (700 / 100) * loadDouble;
}

_setLoadCurrent(String loadPercent, String batteryVolt) {
  double loadpercentDouble = double.parse(loadPercent);
  double loadpowerDouble = (700 / 100) * loadpercentDouble;
  double batteryVoltDouble = double.parse(batteryVolt);
  return loadpowerDouble / batteryVoltDouble;
}

_setBackUpHours(String loadPercent, String batteryVolt) {
  double loadpercentDouble = double.parse(loadPercent);
  double loadpowerDouble = (700 / 100) * loadpercentDouble;
  double batteryVoltDouble = double.parse(batteryVolt);
  double loadCurrent = loadpowerDouble / batteryVoltDouble;
  return (((150 / 100) * 80) / loadCurrent);
}
