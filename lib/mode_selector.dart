//import 'package:flutter/material.dart';
//import 'package:gnu_noti_flutter/list.dart';
//
//class ModeSelector extends StatefulWidget{
//  @override
//  State<StatefulWidget> createState() {
//    return _ModelSelectorState();
//  }
//}
//
//  class _ModelSelectorState extends State<ModeSelector>{
//  int selected = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    return BottomNavigationBar(
//      currentIndex: selected,
//      onTap: naviBarTapped,
//      items: [
//        BottomNavigationBarItem(
//          icon: new Icon(Icons.public),
//          title: new Text("전체"),
//        ),
//        BottomNavigationBarItem(
//            icon: new Icon(Icons.whatshot),
//            title: new Text("HOT NEWS")
//        ),
//        BottomNavigationBarItem(
//          icon: new Icon(Icons.message),
//          title: new Text("기관공지"),
//        )
//      ],
//    );
//  }
//
//  void naviBarTapped(int index){
//    print("변경전: $selected");
//    print(index);
//
//    setState(() {
//      selected = index;
//
//      if (selected == 0){
//        Navigator.of(context).pushReplacementNamed('/List', arguments: 'mix');
//      }
//      else if (selected == 1){
//        print("임시 모드");
////        Navigator.of(context).pushReplacementNamed('/List', arguments: 'dev');
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => ListRoute(),
//            settings: RouteSettings(
//              arguments: 'dev'
//            )
//          )
//        );
//      }
//
//    });
//
//    print("변경후: $selected");
//
//  }
//}