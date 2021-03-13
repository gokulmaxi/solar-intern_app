class JsonData {
  String inputVoltage;
  String outputVoltage;
  String batteryVoltage;
  String loadPercentage;
  String solarStatus;
  String mainStatus;
  String batteryStatus;
  String inverterStatus;
  bool critical;
  bool nonCritical;
  JsonData(
      {this.inputVoltage,
      this.outputVoltage,
      this.batteryStatus,
      this.batteryVoltage,
      this.loadPercentage,
      this.mainStatus,
      this.solarStatus,
      this.inverterStatus,
      this.critical,
      this.nonCritical});
  factory JsonData.fromJson(Map<String, dynamic> parsedJson) {
    return JsonData(
        inputVoltage: parsedJson["input_voltage"],
        outputVoltage: parsedJson["output_voltage"],
        batteryVoltage: parsedJson["battery_voltage"],
        loadPercentage: parsedJson["load_percentage"],
        solarStatus: parsedJson["solarStatus"],
        mainStatus: parsedJson["mainStatus"],
        batteryStatus: parsedJson["batteryStatus"],
        inverterStatus: parsedJson["inverterStatus"],
        critical: parsedJson["critical"],
        nonCritical: parsedJson["non-critical"]);
  }
}
