import 'repository.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
class FirebasePushNotification 
{
    FirebaseMessaging _firebaseMessaging=FirebaseMessaging();
 FirebasePushNotification()
 {
  config();
 }

 void config()
 {
    try {
      
    if(Platform.isIOS)
      {
        _firebaseMessaging.requestNotificationPermissions(
            IosNotificationSettings(sound: true, badge: true, alert: true)
        );
        _firebaseMessaging.onIosSettingsRegistered
            .listen((IosNotificationSettings settings)
        {
          print("Settings registered: $settings");
        });

      }
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
        print(message.length);

      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        print(message.length);
      },
    );

    _firebaseMessaging.getToken().then((token){
      repository.updateFCM(token);
      print(token);
    }); 
   } catch (e) {
   }
 }
}
final firebasePushNotification =FirebasePushNotification();