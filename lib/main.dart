import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gnu_noti_flutter/fcm.dart';
import 'package:gnu_noti_flutter/loading.dart';
import 'package:gnu_noti_flutter/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list.dart';

void main() => runApp(MyApp());

// ignore: non_constant_identifier_names
String DEBUG_CHANNEL = 'mix';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
//    FirebaseMessaging _fcm = FirebaseMessaging();
//    _fcm.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
////        final snackBar = SnackBar(content: Text('New Noti'));
////
////        // Find the Scaffold in the widget tree and use it to show a SnackBar.
////        Scaffold.of(context).showSnackBar(snackBar);
////
////        showDialog(
////          context: context,
////          builder: (context) => AlertDialog(
////            content: ListTile(
////              title: Text(message['notification']['title']),
////              subtitle: Text(message['notification']['body']),
////            ),
////            actions: <Widget>[
////              FlatButton(
////                child: Text('Ok'),
////                onPressed: () => Navigator.of(context).pop(),
////              ),
////            ],
////          ),
////        );
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
////        // TODO optional
////        final snackBar = SnackBar(content: Text('New Noti'));
////
////        // Find the Scaffold in the widget tree and use it to show a SnackBar.
////        Scaffold.of(context).showSnackBar(snackBar);
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        // TODO optional
////        final snackBar = SnackBar(content: Text('New Noti'));
////
////        // Find the Scaffold in the widget tree and use it to show a SnackBar.
////        Scaffold.of(context).showSnackBar(snackBar);
//      },
//    );
//
//    _fcm.subscribeToTopic(DEBUG_CHANNEL);
//
//    // 주의: then 메서드는 콜백함수의 반환값을 처리할 수 없음
//    getStatus().then(
//            (List<bool> values) {
//              List<bool> status = values;
//              print("temp: $status");
//
//              if (values[0] == true){
//                print("subscribe HOT NEWS");
//                _fcm.subscribeToTopic("HOT NEWS");
//              }
//              else{
//                print("unsubscribe HOT NEWS");
//                _fcm.unsubscribeFromTopic("HOT NEWS");
//              }
//
//              if (values[1] == true){
//                print("subscribe AGENCY");
//                _fcm.subscribeToTopic("AGENCY");
//              }
//              else{
//                print("unsubscribe AGENCY");
//                _fcm.unsubscribeFromTopic("AGENCY");
//              }
//            });

    FirebaseCloudMessaging _fcm = FirebaseCloudMessaging();
    _fcm.dev_configure();


    return new MaterialApp(
      home: LoadingRoute(),
      routes: <String, WidgetBuilder>{
        '/List': (BuildContext context) => mainApp(context)
      },
    );
  }

  Widget mainApp(BuildContext context){
    return MaterialApp(
        title: 'GNU-NOTI',
        theme: ThemeData(
            primarySwatch: Colors.blue
        ),
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("GNU-NOTI"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    iconSize: 25,
                    onPressed: () => _settingEvent(context),
                  )
                ],

              ),
//          body: Center(
//            child: NotificationList(),
//          ),
//          bottomNavigationBar: ModeSelector()

              body: TabBarView(
                children: <Widget>[
//                  Icon(Icons.public),
                  NotificationList(ch: "mix",),
                  Icon(Icons.whatshot),
                  NotificationList(ch: 'dev')
                ],
              ),
              bottomNavigationBar: new TabBar(
                tabs: [
                  Tab(text: "전체", icon: Icon(Icons.public)),
                  Tab(text: "HOT NEWS", icon: Icon(Icons.whatshot)),
                  Tab(text: "기관공지", icon: Icon(Icons.message)),
                ],
                labelColor: Colors.black,
              ),
            )
        )
    );
  }

  Future<List<bool>> getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<bool> values = List();
    bool value;

    if (prefs.getBool("HOTNEWS") == null){
      await initStatus();
    }

    value = prefs.getBool("HOTNEWS") ?? prefs.setBool("HOTNEWS", true);
    values.add(value);

    value = prefs.getBool("AGENCY") ?? prefs.setBool("AGENCY", true);
    values.add(value);

    print("Main values: $values");
    return values;
  }

  Future<void> initStatus() async {
    print("설정값 초기화 수행");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("HOTNEWS", true);
    prefs.setBool("AGENCY", true);
  }

  void _settingEvent(BuildContext context){
    print("Setting Button Pressed");
    // TODO: 우선 한 컬랙션에 모두 저장 후 추후 구현
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingRoute())
    );
//    Flushbar(
//      title: "불편을 드려 죄송합니다.",
//      message: "설정기능은 현재 개발중입니다.",
//      duration: Duration(seconds: 3),
//    ).show(context);
  }
}