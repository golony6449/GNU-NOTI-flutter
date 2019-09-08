import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("dev").snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return CircularProgressIndicator();

        return _buildListView(snapshot.data.documents);
      },
    );
  }

  Widget _buildListView(List<DocumentSnapshot> snapshot){
    return ListView(
        padding: EdgeInsets.all(20),
        children: snapshot.map((data) => _buildListItem(data)).toList()
    );
  }
  Widget _buildListItem(DocumentSnapshot snapshot){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(snapshot.data['title']),
            subtitle: Text(snapshot.data['category']),
            onTap: () => launch(snapshot.data['url']),
          ),
        )
    );
  }
}