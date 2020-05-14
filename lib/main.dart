import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gnu_noti_flutter/fcm.dart';
import 'package:gnu_noti_flutter/intro_screen.dart';
import 'package:gnu_noti_flutter/loading.dart';
import 'package:gnu_noti_flutter/main_drawer.dart';
import 'package:gnu_noti_flutter/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list.dart';

void main() => runApp(MyApp());

// ignore: non_constant_identifier_names
bool DEBUG = true;

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    FirebaseCloudMessaging _fcm = FirebaseCloudMessaging();
    if (DEBUG == true) {
      print("디버깅 모드");
//      _fcm.dev_configure();
    }

    this.getStatus();


    return new MaterialApp(
      home: LoadingRoute(),
      routes: <String, WidgetBuilder>{
        '/List': (BuildContext context) => mainApp(context),
        '/Intro': (BuildContext context) => IntroScreen()
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
              drawer: MainDrawer(),
              appBar: AppBar(
                title: Text("GNU-NOTI"),
                actions: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.settings),
//                    iconSize: 25,
//                    onPressed: () => _settingEvent(context),
//                  )
                ],

              ),

              body: TabBarView(
                children: <Widget>[
                  NotificationList(ch: "mix",),
                  NotificationList(ch: "gnu"),
                  NotificationList(ch: "agency")
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
    prefs.setBool("FIRSTRUN", true);

    //  FCM 추가 구성
    FirebaseCloudMessaging _fcm = FirebaseCloudMessaging();
    _fcm.subscribe("gnu");
    _fcm.subscribe("agency");
    if (DEBUG == true){
      _fcm.dev_configure();
    }

    // 팝업
//    // 테스트용 코드
//      showDialog(
//        context: context,
//        builder: (BuildContext context) => _popupNotification(context)
//      );

  }

  void _settingEvent(BuildContext context){
    print("Setting Button Pressed");
    // TODO: 우선 한 컬랙션에 모두 저장 후 추후 구현
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingRoute())
    );
  }

  Widget _popupNotification(BuildContext context) {
    return AlertDialog(
        title: Text("환영합니다."),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
              Text("공지사항 알리미는 새로운 공지사항이 등록되었을 때 Push 알림을 수신할 수 있습니다."),
              Text("Push 알림을 수신할 수 없을 경우, 설정에서 수신해제후 다시 수신으로 등록해주세요."),
      ],
          ),

        actions: <Widget>[
          FlatButton(
            child: Text("닫기"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          FlatButton(
            child: Text("오늘 하루 열지 않기"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]);
  }
}