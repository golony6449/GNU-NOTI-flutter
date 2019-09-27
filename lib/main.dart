import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gnu_noti_flutter/loading.dart';
import 'package:gnu_noti_flutter/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list.dart';

void main() => runApp(MyApp());

// ignore: non_constant_identifier_names
String DEBUG_CHANNEL = 'mix';

class MyApp extends StatelessWidget{
  List<bool> status;

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging _fcm = FirebaseMessaging();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
//        final snackBar = SnackBar(content: Text('New Noti'));
//
//        // Find the Scaffold in the widget tree and use it to show a SnackBar.
//        Scaffold.of(context).showSnackBar(snackBar);
//
//        showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle: Text(message['notification']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//        // TODO optional
//        final snackBar = SnackBar(content: Text('New Noti'));
//
//        // Find the Scaffold in the widget tree and use it to show a SnackBar.
//        Scaffold.of(context).showSnackBar(snackBar);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
//        final snackBar = SnackBar(content: Text('New Noti'));
//
//        // Find the Scaffold in the widget tree and use it to show a SnackBar.
//        Scaffold.of(context).showSnackBar(snackBar);
      },
    );

    _fcm.subscribeToTopic(DEBUG_CHANNEL);

    // 주의: then 메서드는 콜백함수의 반환값을 처리할 수 없음
    getStatus().then(
            (List<bool> values) {
              status = values;
            });

    return new MaterialApp(
      home: LoadingRoute(),
      routes: <String, WidgetBuilder>{
        '/List': (BuildContext context) => new ListRoute()
      },
    );
  }

  Future<List<bool>> getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<bool> values = List();
    bool value;
//    print(prefs.getBool("HOTNEWS"));
    if (prefs.getBool("HOTNEWS") == null){
      await initStatus();
    }

    value = prefs.getBool("HOTNEWS") ?? prefs.setBool("HOTNEWS", true);
    values.add(value);

    value = prefs.getBool("AGENCY") ?? prefs.setBool("AGENCY", true);
    values.add(value);

    value = prefs.getBool("CS") ?? prefs.setBool("CS", false);
    values.add(value);
    print("Main values: $values");
    return values;
  }
  Future<void> initStatus() async {
    print("설정값 초기화 수행");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("HOTNEWS", true);
    prefs.setBool("AGENCY", true);
    prefs.setBool("CS", false);
  }
}