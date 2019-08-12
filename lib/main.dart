import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
              onPressed: _settingEvent,
            )
          ],

        ),
        body: Center(
            child: NotificationList(),
        )
      )
    );
  }

  void _settingEvent(){
    print("Setting Button Pressed");
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
            title: _buildList(i)
          );
        }
    );
  }

  Widget _buildList(int i){
    return Text(i.toString());
  }
}