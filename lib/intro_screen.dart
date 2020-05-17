import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    // TODO: 다국어 지원
    List<String> descriptions = [
      '''
이 앱은 비공식 앱 입니다. \n\n
반드시 공지사항 원문의 링크를 확인해주세요.
      ''',
      '''
공지사항에 대해 Push 서비스를 제공합니다.\n\n
    ''',
      '''
설정에서 수신할 항목을 선택할 수 있습니다.
      ''',
      '''
동작하지 않을 때는 설정에서 항목을 재등록 해보세요.
      '''
    ];

    slides.add(
      new Slide(
        title: "환영합니다.",
        description: descriptions[0],
        pathImage: "assets/image/logo.png",
        widthImage: 200.0,
        heightImage: 200.0,
        backgroundColor: Color(0xff2857a2),
      ),
    );
    
    // TODO: GIF 제작
    slides.add(
      new Slide(
        title: "공지사항을 편리하게!",
        description: descriptions[1],
        pathImage: "assets/image/test.gif",
        backgroundColor: Color(0xff6083d4),
      ),
    );

    slides.add(
      new Slide(
        title: "수신할 항목 선택하기.",
        description: descriptions[2],
        backgroundColor: Color(0xff00acad),
      )
    );

    slides.add(
      new Slide(
        title: "수신할 항목 선택하기.",
        description: descriptions[3],
        backgroundColor: Color(0xff56c8d8),
      )
    );
  }

  void onDonePress() async {
    setFirstBootPrefs(false);
    Navigator.of(context).pushReplacementNamed("/List", arguments: "mix");
  }

  void onSkipPress() async {
    setFirstBootPrefs(false);
    Navigator.of(context).pushReplacementNamed("/List", arguments: "mix");
  }

  void setFirstBootPrefs(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("set FIRSTRUN param: $value");
    await prefs.setBool("FIRSTRUN", value);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}