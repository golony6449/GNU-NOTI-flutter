import 'package:flutter/material.dart';
import 'package:gnu_noti_flutter/intro_screen.dart';
import 'package:gnu_noti_flutter/setting.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;

    return Container(
        width: screen_width * 0.4,
        child: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text("경상대학교 공지사항 알리미"),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("설정"),
                onTap: () => _settingEvent(context),
              ),
              ListTile(
                leading: Icon(Icons.help_outline),
                  title: Text("도움말"),
                  onTap: () => _introHelpScreenEvent(context),
              ),
            ],
          ),
        )
    );
  }

  void _settingEvent(BuildContext context){
    print("Setting Button Pressed");
    // TODO: 우선 한 컬랙션에 모두 저장 후 추후 구현
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingRoute())
    );
  }

  void _introHelpScreenEvent(BuildContext context){
    print("Help Button Pressed");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IntroScreen())
    );
  }
}