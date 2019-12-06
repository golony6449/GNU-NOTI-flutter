import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseCloudMessaging{
  static final FirebaseCloudMessaging singleton = new FirebaseCloudMessaging._init();
  static FirebaseMessaging _fcm;

  factory FirebaseCloudMessaging() {
    return singleton;
  }

  FirebaseCloudMessaging._init(){
    _fcm = FirebaseMessaging();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  void configure(bool gnu, bool agency){
    if (gnu == true){
      _fcm.subscribeToTopic("gnu");
    }
    else {
      _fcm.unsubscribeFromTopic("gnu");
    }

    if (agency == true){
      _fcm.subscribeToTopic("agency");
    }
    else {
      _fcm.unsubscribeFromTopic("agency");
    }
  }

  void subscribe(String ch){
    _fcm.subscribeToTopic(ch);
  }

  void unsubscribe(String ch){
    _fcm.unsubscribeFromTopic(ch);
  }

  void dev_configure(){
    _fcm.subscribeToTopic("dev");
  }
}