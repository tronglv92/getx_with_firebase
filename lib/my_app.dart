import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_getx_boilerplate/routes/app_pages.dart';
import 'package:flutter_getx_boilerplate/shared/utils/app_log.dart';
import 'package:flutter_getx_boilerplate/theme/theme_data.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/smart_management.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import 'app_binding.dart';
import 'lang/translation_service.dart';
import 'main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  await Firebase.initializeApp();
  if (USE_EMULATOR) {
    await connectToFirebaseEmulator();
  }

  showNotification(title: message.data['title'],message: message.data['body']);
  logger.d('Handling a background message ${message.toString()}');
}
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> myMain() async {
  // Start services later
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    // // // Create an Android Notification Channel.
    // NotificationSettings settings =
    //     await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    //
    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   logger.d('User granted permission');
    // } else if (settings.authorizationStatus ==
    //     AuthorizationStatus.provisional) {
    //   logger.d('User granted provisional permission');
    // } else {
    //   logger.d('User declined or has not accepted permission');
    // }

    // Update the iOS foreground notification presentation options to allow
    // heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Force portrait mode
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  //set up flutter local notification

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          onDidReceiveLocalNotification:
              (int a, String? b, String? c, String? d) {});
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? a) {});

  // Run Application
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? fcmToken;

  @override
  void initState() {
    super.initState();

    /// Init page
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await initFirebase();
    });

    // firebase message
  }

  Future<void> initFirebase() async {
    fcmToken = await FirebaseMessaging.instance.getToken();
    //update value fcm token

    logger.d('FCM Token : $fcmToken');
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      logger.d('Firebase getInitialMessage message ', message);
      // showNotification();
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('Firebase onMessage !', message);
      showNotification(title: message.data['title'],message: message.data['body']);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.d('Firebase onMessageOpenedApp ',message);
    });
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      logger.d('FlutterFire Messaging Example: Getting APNs token...');
      String? aPNSToken = await FirebaseMessaging.instance.getAPNSToken();
      logger.d('FlutterFire Messaging Example: Got APNs token: $aPNSToken');
    } else {
      logger.d(
          'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Init dynamic size
    /// https://pub.dev/packages/flutter_screenutil
    ///    ScreenUtil().pixelRatio       //Device pixel density
    ///    ScreenUtil().screenWidth   (sdk>=2.6 : 1.sw)    //Device width
    ///    ScreenUtil().screenHeight  (sdk>=2.6 : 1.sh)    //Device height
    ///    ScreenUtil().bottomBarHeight  //Bottom safe zone distance, suitable for buttons with full screen
    ///    ScreenUtil().statusBarHeight  //Status bar height , Notch will be higher Unit px
    ///    ScreenUtil().textScaleFactor  //System font scaling factor
    ///
    ///    ScreenUtil().scaleWidth //Ratio of actual width dp to design draft px
    ///    ScreenUtil().scaleHeight //Ratio of actual height dp to design draft px
    ///
    ///    0.2.sw  //0.2 times the screen width
    ///    0.5.sh  //50% of screen height
    /// Set the fit size (fill in the screen size of the device in the design)
    /// https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
    ///    iPhone 2, 3, 4, 4s                => 3.5": 320 x 480 (points)
    ///    iPhone 5, 5s, 5C, SE (1st Gen)    => 4": 320 × 568 (points)
    ///    iPhone 6, 6s, 7, 8, SE (2st Gen)  => 4.7": 375 x 667 (points)
    ///    iPhone 6+, 6s+, 7+, 8+            => 5.5": 414 x 736 (points)
    ///    iPhone 11Pro, X, Xs               => 5.8": 375 x 812 (points)
    ///    iPhone 11, Xr                     => 6.1": 414 × 896 (points)
    ///    iPhone 11Pro Max, Xs Max          => 6.5": 414 x 896 (points)
    ///    iPhone 12 mini                    => 5.4": 375 x 812 (points)
    ///    iPhone 12, 12 Pro                 => 6.1": 390 x 844 (points)
    ///    iPhone 12 Pro Max                 => 6.7": 428 x 926 (points)
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        enableLog: true,
        initialRoute: AppRoutes.HOME,
        defaultTransition: Transition.fade,
        getPages: AppPages.routes,
        initialBinding: AppBinding(),
        smartManagement: SmartManagement.keepFactory,
        title: 'GetX',
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        locale: TranslationService.locale,
        fallbackLocale: TranslationService.fallbackLocale,
        translations: TranslationService(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
