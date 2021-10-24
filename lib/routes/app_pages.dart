
import 'package:flutter_getx_boilerplate/screens/notifications/notification.dart';
import 'package:flutter_getx_boilerplate/screens/product/product_binding.dart';
import 'package:flutter_getx_boilerplate/screens/product/product_screen.dart';
import 'package:flutter_getx_boilerplate/screens/profile/profile.dart';
import 'package:flutter_getx_boilerplate/screens/scheno/schedule_binding.dart';
import 'package:flutter_getx_boilerplate/screens/scheno/schedule_screen.dart';
import 'package:flutter_getx_boilerplate/screens/search/search_binding.dart';
import 'package:flutter_getx_boilerplate/screens/search/search_screen.dart';


import 'package:flutter_getx_boilerplate/screens/splash/splash_binding.dart';
import 'package:flutter_getx_boilerplate/screens/splash/splash_screen.dart';
import 'package:flutter_getx_boilerplate/screens/home/home_binding.dart';
import 'package:flutter_getx_boilerplate/screens/home/home_screen.dart';
import 'package:flutter_getx_boilerplate/screens/login/login_binding.dart';
import 'package:flutter_getx_boilerplate/screens/login/login_screen.dart';

import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
        name: AppRoutes.PROFILE,
        page: () => ProfileScreen(),
        binding: ProfileBinding(),
        children: []),
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATION,
      page: () => NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRoutes.PRODUCT,
      page: () => ProductScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: AppRoutes.SCHEDULE_NOTIFICATION,
      page: () =>  ScheduleScreen(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: AppRoutes.SEARCH,
      page: () =>  SearchScreen(),
      binding: SearchBinding(),
    ),
  ];
}
