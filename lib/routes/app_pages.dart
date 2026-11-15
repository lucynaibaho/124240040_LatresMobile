import 'package:get/get.dart';

import '../bindings/detail_binding.dart';
import '../bindings/home_binding.dart';
import '../middleware/auth_middleware.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/detail_screen.dart';
import '../views/profile_screen.dart';
import '../views/root_screen.dart';
import '../views/splash_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const detail = '/detail';
  static const profile = '/profile';
}

abstract final class AppPages {
  static final pages = <GetPage<void>>[
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(
      name: AppRoutes.home,
      page: () => const RootScreen(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailScreen(),
      binding: DetailBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
