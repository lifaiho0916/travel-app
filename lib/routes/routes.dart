import 'package:get/get.dart';
import 'package:travel/screens/auth/country_code_screen.dart';
import 'package:travel/screens/auth/register_screen.dart';
import 'package:travel/screens/auth/sign_in_screen.dart';
import 'package:travel/screens/car_view_screen.dart';
import 'package:travel/screens/duty_screen.dart';
import 'package:travel/screens/home_screen.dart';
import 'package:travel/screens/hotel_details_screen.dart';
import 'package:travel/screens/hotel_view_screen.dart';
import 'package:travel/screens/package_view_screen.dart';
import 'package:travel/screens/profile_screen.dart';
import 'package:travel/screens/restaurant_screen.dart';
import 'package:travel/screens/search_screen.dart';
import 'package:travel/screens/splash_screen.dart';

class Routes {
  static final routes = [
    GetPage(name: '/', page: () => const SplashScreen()),
    GetPage(name: '/signin', page: () => const SignInScreen()),
    GetPage(name: '/signup', page: () => const SignUpScreen()),
    GetPage(name: '/country_code', page: () => const CountryCodeScreen()),
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: '/hotel_details', page: () => const HotelDetailsScreen()),
    GetPage(name: '/hotel', page: () => const HotelViewScreen()),
    GetPage(name: '/car', page: () => const CarViewScreen()),
    GetPage(name: '/package', page: () => const PackageViewScreen()),
    GetPage(name: '/profile', page: () => const ProfileScreen()),
    GetPage(name: '/duty', page: () => const DutyScreen()),
    GetPage(name: '/restaurant', page: () => const RestaurantScreen()),
    GetPage(name: '/search', page: () => const SearchScreen()),
  ];
}
