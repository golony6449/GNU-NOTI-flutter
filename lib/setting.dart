import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gnu_noti_flutter/fcm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설정"),
      ),
      body: FutureBuilder(
        future: getStatus(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            print("데이터 준비중");
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.hasError){
            Text("ERROR: $snapshot.error");
          }
          // TODO: 데이터 준비가 너무 빨라, 버벅이는 것 처럼 보이는 문제 발생

          print("데이터 준비 끝");
          SettingListState.status = snapshot.data;
          return SettingList();
        },
      )
    );
  }

  Future<List<bool>> getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<bool> values = List();
    bool value;

    value = prefs.getBool("HOTNEWS") ?? prefs.setBool("HOTNEWS", true);
    values.add(value);

    value = prefs.getBool("AGENCY") ?? prefs.setBool("AGENCY", true);
    values.add(value);

    return values;
  }
}

class SettingList extends StatefulWidget{
  @override
  SettingListState createState() => SettingListState();
}

class SettingListState extends State<SettingList>{
  static List<bool> status;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, i) => Divider(
          color: Colors.black
        ),
        itemCount: 3,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          return SettingListTile(
            i: i,
            status: status,
            switchEvent: switchValueChanged,
          );
        }
    );
  }

  Future<List<bool>> getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<bool> values = List();
    bool value;

    value = prefs.getBool("HOTNEWS") ?? prefs.setBool("HOTNEWS", true);
    values.add(value);

    value = prefs.getBool("AGENCY") ?? prefs.setBool("AGENCY", true);
    values.add(value);

    // TODO: 이유는 모르겠으나, Duration이 적용되지 않음
//    return await Future.delayed(Duration(seconds: 5), () => values);
    await new Future.delayed(Duration(seconds: 2), () => {print("Delay 완료")});
    return values;
  }

  Future<void> setStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("HOTNEWS", status[0]);
    prefs.setBool("AGENCY", status[1]);
  }

  void switchValueChanged(int i, bool value){
    FirebaseCloudMessaging _fcm = FirebaseCloudMessaging();
    if (i == 0){
      if (value == true) {
        _fcm.subscribe("gnu");
        print("HOT NEWS 구독");
      }
      else {
        _fcm.unsubscribe("gnu");
        print("HOT NEWS 구독 해지");
      }
    }
    else if (i == 1) {
      if (value == true) {
        _fcm.subscribe("agency");
        print("기관공지 구독");
      }
      else {
        _fcm.unsubscribe("agency");
        print("기관공지 구독 해지");
      }
    }

    status[i] = value;
    print("Switch: Status Changed");
    print("$i: $value");
    setStatus();

    setState(() {});
  }
}

class SettingListTile extends StatelessWidget{
  List<bool> status;
  int i;
  Function switchEvent;

  SettingListTile({Key key, @required this.i, @required this.status, @required this.switchEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (i == 2){
      return ListTile(
        title: Text("텔레그램 채널로 이동"),
        onTap: _telegramLaunch,
        subtitle: Text("텔레그램으로도 동일한 알림을 받을 수 있습니다."),
      );
    }

    return ListTile(
      title: _buildListElementText(i),
      subtitle: _buildListElementDesc(i),
      trailing: _buildListElementSwitch(i),
    );
  }

  Widget _buildListElementText(int i){
    List<String> options = ["HOT NEWS", "기관공지"];
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Text(options[i])
    );
  }

  Widget _buildListElementDesc(int i){
    List<String> desc = [
      "공식 홈페이지의 HOT NEWS 게시판에서 새로운 공지사항을 가져옵니다.",
      "공식 홈페이지의 기관공지 게시판에서 새로운 공지사항을 가져옵니다.",
    ];

    return Text(desc[i]);
  }

  // TODO: 설정 값 저장
  // TODO: 스위치 토글시 화면 갱신
  Widget _buildListElementSwitch(int i){
    return Switch(
      onChanged: (bool value) {
        switchEvent(i, value);
      },
      value: status[i],
    );
  }

  void _telegramLaunch(){
    launch("https://t.me/GNU_NOTI");
  }
}