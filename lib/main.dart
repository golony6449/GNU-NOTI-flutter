import 'package:flutter/material.dart';
import 'package:gnu_noti_flutter/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  List<bool> status;

  @override
  Widget build(BuildContext context) {
    // 주의: then 메서드는 콜백함수의 반환값을 처리할 수 없음
    getStatus().then(
            (List<bool> values) {
              status = values;
            });

    return new MaterialApp(
      home: ListRoute()
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

class ListRoute extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue
      ),
      home: Scaffold(
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
        body: Center(
            child: NotificationList(),
        )
      )
    );
  }

  void _settingEvent(BuildContext context){
    print("Setting Button Pressed");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingRoute())
    );
  }
}

class NotificationList extends StatefulWidget{
  @override
  NotificationListState createState() => NotificationListState();
}

class NotificationListState extends State<NotificationList>{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          return ListTile(
            title: _buildList(i),
            onTap: _launch,
          );
        }
    );
  }

  Widget _buildList(int i){
    return Text(i.toString());
  }

  void _launch() {
    launch("http://www.gnu.ac.kr");
  }
}