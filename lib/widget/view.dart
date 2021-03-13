import 'package:flutter/material.dart';
import 'package:solar/mqtt/mqttManager.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:solar/mqtt/mqttState.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:custom_switch/custom_switch.dart';

class View extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ViewState();
  }
}

class _ViewState extends State<View> {
  MQTTAppState currentAppState;
  MQTTManager manager;
  @override
  void initState() {
    super.initState();
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(identifier: osPrefix, state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    manager.currentState = currentAppState;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('MQTT'),
            backgroundColor: Color(0XFF0ED2F7),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _radialGuage(currentAppState.getInputVoltage, 0, 300,
                            "mains", "voltage"),
                        _radialGuage(currentAppState.getOutputVoltage, 0, 300,
                            "inverter", "volatage"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _radialGuage(currentAppState.getBatteryVoltage, 0, 12,
                            "bat", "voltage"),
                        _radialGuage(currentAppState.getLoadPercentage, 0, 100,
                            "load", "percentage")
                      ],
                    ),
                  ),
                  // newMethod("Load Power : ", 329, "W"),
                  //newMethod("Load Current : ", 14.572, "A"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 165,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            // color: Colors.white, //background color of box
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0, // soften the shadow
                              spreadRadius: 3.0, //extend the shadow
                              offset: Offset(
                                5.0, // Move to right 10  horizontally
                                5.0, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Load Power\t:\t" +
                                  currentAppState.getLoadPower
                                      .toStringAsFixed(2),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Load Current\t:\t" +
                                  currentAppState.getLoadCurrent
                                      .toStringAsFixed(2),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Backup hours\t:\t" +
                                  currentAppState.getBackupHour
                                      .toStringAsFixed(2),
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Solar Status\t:\t" +
                                  currentAppState.getSolarStatus,
                              style: TextStyle(fontSize: 25),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                            child: inkwell(
                                currentAppState.getInverterBoolStatus,
                                "inverter",
                                "inverter")),
                        inkwell(currentAppState.getCriticalLoadStatus,
                            "critical load", "critical_load"),
                        inkwell(currentAppState.getNonCriticalLoadStatus,
                            "non critical load", "non_critical_load"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  InkWell inkwell(bool isSwitched, String title, String topic) {
    return InkWell(
      onTap: () {
        print("pressed");
        _publishMessage(!isSwitched, topic);
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              // color: Colors.white, //background color of box
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0, // soften the shadow
                spreadRadius: 3.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 10  horizontally
                  5.0, // Move to bottom 10 Vertically
                ),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  color: isSwitched ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                    child: Text(isSwitched ? "On" : "off",
                        style: TextStyle(fontSize: 20))),
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _publishMessage(bool state, String topic) {
    if (state) {
      manager.publish("on", "gokul/" + topic);
    } else {
      manager.publish("off", "gokul/" + topic);
    }
  }
}

Widget _radialGuage(double value, double startpoint, double endpoint,
    String title, String annotation) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            // color: Colors.white, //background color of box
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 3.0, //extend the shadow
              offset: Offset(
                5.0, // Move to right 10  horizontally
                5.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 130,
            child: SfRadialGauge(
                title: GaugeTitle(
                    text: title,
                    textStyle:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                axes: <RadialAxis>[
                  RadialAxis(
                      minimum: startpoint,
                      maximum: endpoint,
                      showLabels: false,
                      showTicks: false,
                      radiusFactor: 0.7,
                      axisLineStyle: AxisLineStyle(
                          cornerStyle: CornerStyle.bothCurve,
                          color: Colors.black12,
                          thickness: 10),
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: value,
                            cornerStyle: CornerStyle.bothCurve,
                            width: 10,
                            sizeUnit: GaugeSizeUnit.logicalPixel,
                            gradient: const SweepGradient(colors: <Color>[
                              Color(0xFFB2FEFA),
                              Color(0xFF0ED2F7)
                            ], stops: <double>[
                              0.50,
                              1
                            ])),
                        MarkerPointer(
                            value: value,
                            enableDragging: false,
                            markerHeight: 15,
                            markerWidth: 15,
                            markerType: MarkerType.circle,
                            color: Color(0xFF0ED2F7),
                            borderWidth: 2,
                            borderColor: Colors.white54)
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            angle: 90,
                            axisValue: 5,
                            positionFactor: 0.2,
                            widget: Text(value.toString(),
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF007EA7))))
                      ])
                ]),
          ),
          Text(
            annotation,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
