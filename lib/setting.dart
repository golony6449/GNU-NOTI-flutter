import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설정"),
      ),
      body: SettingList()
    );
  }
}

class SettingList extends StatefulWidget{
  @override
  SettingListState createState() => SettingListState();
}

class SettingListState extends State<SettingList>{
  List<bool> status = List();

  @override
  Widget build(BuildContext context) {
    getStatus().then(
        (List<bool> values){
//          print("Setting status: $values");
          status = values;
          print("Setting values: $status");
        }
    );

    return ListView.separated(
        separatorBuilder: (context, i) => Divider(
          color: Colors.black
        ),
        itemCount: 3,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, i) {
          return ListTile(
            title: _buildListElementText(i),
            subtitle: _buildListElementDesc(i),
            trailing: _buildListElementSwitch(i),
          );
        }
    );
  }

  Widget _buildListElementText(int i){
    List<String> options = ["HOT NEWS", "기관공지", "컴퓨터과학과"];
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(options[i])
    );
  }
  
  Widget _buildListElementDesc(int i){
    List<String> desc = [
      "공식 홈페이지의 HOT NEWS 게시판에서 새로운 공지사항을 가져옵니다.",
      "공식 홈페이지의 기관공지 게시판에서 새로운 공지사항을 가져옵니다.",
      "자연과학대학 컴퓨터과학과의 새로운 공지사항을 가져옵니다."
    ];
    
    return Text(desc[i]);
  }

  // TODO: 설정 값 저장
  // TODO: 스위치 토글시 화면 갱신
  Widget _buildListElementSwitch(int i){
    return Switch(
      onChanged: (bool value) {
        status[i] = value;
        print("Switch: Status Changed");
        print("Menu: $value");
        setStatus();

        setState(() {});
      },
      value: status[i],
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

    value = prefs.getBool("CS") ?? prefs.setBool("CS", false);
    values.add(value);

    return values;
  }

  Future<void> setStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("HOTNEWS", status[0]);
    prefs.setBool("AGENCY", status[1]);
    prefs.setBool("CS", status[2]);
  }
}