import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:flutter_mqtt_app/mqtt/state/MQTTAppState.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import 'package:solar/mqtt/mqttState.dart';
import 'dart:convert';
import 'package:solar/mqtt/jsonHandler.dart';

parseJson(String jsonString) {
  final jsonResponse = json.decode(jsonString);
  JsonData data = new JsonData.fromJson(jsonResponse);
  return data;
}

class MQTTManager {
  // Private instance of client
  // final MQTTAppState _currentState;
  String mVoltage;
  MqttServerClient _client;
  final String _identifier;
  MQTTAppState currentState;
  // Constructor
  MQTTManager({@required String identifier, @required MQTTAppState state
      // @required MQTTAppState state
      })
      : _identifier = identifier,
        currentState = state;

  void initializeMQTTClient() {
    _client = MqttServerClient("broker.hivemq.com", _identifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure = false;
    _client.logging(on: true);

    /// Add the successful connection callback
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier("client 1")
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client.connectionMessage = connMess;
  }

  // Connect to the host
  Future<void> connect() async {
    assert(_client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      // _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.disconnect();
  }

  void publish(String message, String topic) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    // _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    // _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('EXAMPLE::Mosquitto client connected....');
    _client.subscribe("gokul/data", MqttQos.atLeastOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // _currentState.setReceivedText(pt);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      switch (c[0].topic) {
        case "gokul/data":
          print("Mvolt app detected");
          JsonData parsedJson = parseJson(pt);
          currentState.setData(parsedJson);

          break;
        default:
      }
      print('');
    });
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }
}
