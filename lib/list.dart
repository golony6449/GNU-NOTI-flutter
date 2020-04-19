import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: non_constant_identifier_names
// String DEBUG_CHANNEL = 'mix';
String DEBUG_CHANNEL = 'dev';

class NotificationList extends StatefulWidget{
  String ch;

  NotificationList({Key key, @required this.ch}) : super(key: key);

  @override
  NotificationListState createState() => NotificationListState();
}

// reference
// https://medium.com/saugo360/flutter-creating-a-listview-that-loads-one-page-at-a-time-c5c91b6fabd3
// https://medium.com/@jimmyhott/using-futurebuilder-to-create-a-better-widget-4c7d4f52a329
// keyword: flutter listtile loading, futurebuilder firestore


class NotificationListState extends State<NotificationList>{
  @override
  Widget build(BuildContext context) {
    String channel = widget.ch;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(channel).orderBy('id', descending: true).snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) {
          print('준비중');
          return Center(
            child: CircularProgressIndicator(),
          );
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
    Color color;
    if (snapshot.data['category'] == "기관공지"){
      color = Color.fromRGBO(255, 254, 76, 0.4);
    }
    else {
      color = Color.fromRGBO(128, 222, 234, 0.4);
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
            color: color,
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