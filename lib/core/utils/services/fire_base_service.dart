// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../firebase_options.dart';
import '../../databases/cache/cache_keys.dart';
import '../../databases/cache/secure_storage_helper.dart';
import 'service_locator.dart';

class FireBaseService {
  //create an instance of Firebase Messaging:
  final _firebaseMessaging = FirebaseMessaging.instance;

  final SecureStorageHelper cache;
  FireBaseService() : cache = getIt<SecureStorageHelper>();

  //initialize app for firebase:
  static Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //function to initialize notifications:
  Future<void> initNotifications() async {
    //request premission from user:
    await _firebaseMessaging.requestPermission();

    //fetch the FCM token for this device:
    String? fcmToken = await getFCMToken();

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await cache.saveData(key: CacheKeys.fcmToken, value: newToken);
      fcmToken = newToken;
      log("token is refreshed: $newToken");
    });

    //print the token:
    log("Token: $fcmToken");
  }

  Future<String?> getFCMToken() async {
    if (await cache.getData(key: CacheKeys.fcmToken) == null) {
      final fcmToken = await _firebaseMessaging.getToken();
      await cache.saveData(key: CacheKeys.fcmToken, value: fcmToken);
      log('token is saved');
      return fcmToken!;
    }
    log('token is retrieve from cache');
    return await cache.getData(key: CacheKeys.fcmToken);
  }
}
