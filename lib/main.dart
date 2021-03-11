import 'package:flutter/material.dart';
import 'package:solar/mqtt/mqttManager.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import 'package:solar/mqtt/mqttState.dart';
import 'package:solar/widget/view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    final MQTTManager manager = MQTTManager(host:'test.mosquitto.org',topic:'flutter/amp/cool',identifier:'ios');
    manager.initializeMQTTClient();
     */

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChangeNotifierProvider<MQTTAppState>(
          create: (_) => MQTTAppState(),
          child: View(),
        ));
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   bool isSwitched = false;
//   MQTTManager manager;
//   MQTTAppState currentState;
//   @override
//   void initState() {
//     super.initState();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<MQTTAppState>(
//       create: (context) => MQTTAppState(),
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           title: Text("Flutter Switch Example"),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Switch(
//                 value: isSwitched,
//                 onChanged: (value) {
//                   setState(() {
//                     isSwitched = value;
//                     print(isSwitched);
//                     manager.publish(isSwitched.toString(), "gokul/switch");
//                   });
//                 },
//                 activeTrackColor: Colors.lightGreenAccent,
//                 activeColor: Colors.green,
//               ),
//               Text(currentState.getInverterVoltage.toString())
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
