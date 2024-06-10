import 'package:flutter/widgets.dart';
import 'package:tugas_uasppb/screens/cart/cart_screen.dart';
import 'package:tugas_uasppb/screens/home/home_screen.dart';
import 'package:tugas_uasppb/screens/sign_in/sign_in_screen.dart';
import 'package:tugas_uasppb/screens/sign_up/sign_up_screen.dart';
import 'package:tugas_uasppb/screens/home/components/home_page.dart';



final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUp.routeName: (context) => const SignUp(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  HomePage.routeName: (context) => const HomePage(),
};
