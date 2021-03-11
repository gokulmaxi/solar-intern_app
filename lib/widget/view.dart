import 'package:flutter/material.dart';
import 'package:solar/mqtt/mqttManager.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:solar/mqtt/mqttState.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    bool showFirstContainer = true;
    final Scaffold scaffold = Scaffold(
        appBar: AppBar(
          title: const Text('MQTT'),
          backgroundColor: Color(0XFF0ED2F7),
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _radialGuage(currentAppState.getInputVoltage, 0, 300),
                  _radialGuage(currentAppState.getOutputVoltage, 0, 300),
                ],
              ),
              Row(
                children: [
                  _radialGuage(currentAppState.getBatteryVoltage, 0, 12),
                  _radialGuage(currentAppState.getLoadPercentage, 0, 100)
                ],
              ),
              Container(
                height: 200,
                width: 340,
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
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "load Power:" + "329" + "W",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "load Current:" + "14.572" + "A",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "load Power:" + "8 " + "hr" + "30" + "min",
                        style: TextStyle(fontSize: 30),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  RaisedButton(
                      color: Colors.blue.shade200,
                      child: new Text("Inverter"),
                      onPressed: () {})
                ],
              )
            ],
          ),
        ));
    return scaffold;
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _publishMessage(String text, String topic) {
    final String message = text;
    manager.publish(message, topic);
  }
}

Widget _radialGuage(double value, double startpoint, double endpoint) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      width: 150,
      height: 150,
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
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: SfRadialGauge(axes: <RadialAxis>[
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
                  gradient: const SweepGradient(
                      colors: <Color>[Color(0xFFB2FEFA), Color(0xFF0ED2F7)],
                      stops: <double>[0.50, 1])),
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
  );
}
