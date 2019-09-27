import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: non_constant_identifier_names
String DEBUG_CHANNEL = 'mix';

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
          ),
//          bottomNavigationBar: BottomNavigationBar(
//            currentIndex: 0,
//            items: [
//              BottomNavigationBarItem(
//                  icon: new Icon(Icons.whatshot),
//                  title: new Text("HOT NEWS")
//              ),
//              BottomNavigationBarItem(
//                  icon: new Icon(Icons.message),
//                  title: new Text("기관공지")
//              )
//            ],
//          ),
        )
    );
  }

  void _settingEvent(BuildContext context){
    print("Setting Button Pressed");
    // TODO: 우선 한 컬랙션에 모두 저장 후 추후 구현
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => SettingRoute())
//    );
    Flushbar(
      title: "불편을 드려 죄송합니다.",
      message: "설정기능은 현재 개발중입니다.",
      duration: Duration(seconds: 3),
    ).show(context);
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
      stream: Firestore.instance.collection(DEBUG_CHANNEL).orderBy('id', descending: true).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) {
          print('준비중');
          return CircularProgressIndicator();
        }
        print("로딩중");

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