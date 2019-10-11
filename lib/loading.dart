import 'dart:async';
import 'package:flutter/material.dart';

class LoadingRoute extends StatefulWidget {
  @override
  _LoadingRouteState createState() => new _LoadingRouteState();
}

class _LoadingRouteState extends State<LoadingRoute> {
  startTime() async {
    var _duration = new Duration(seconds: 3 );
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/List');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            new Align(
              alignment: Alignment(0, -0.3),
              child: new Image.asset('assets/image/logo.png', width: 200, height: 200,),
            ),

            new Align(
              alignment: Alignment(0, 0.3),
              child: Text(
                '경상대학교 공지사항 알리미',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            ),

            new Align(
              alignment: Alignment(0, 0.4),
              child: Text("비공식 앱 입니다. 반드시 원문의 링크를 확인해주세요."),
            ),
          ],
        )
    );

  }
}