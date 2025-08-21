import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/pages/screen/home_screen.dart';
import 'features/authentication/presentation/pages/screen/splash_screen.dart';
import 'features/authentication/presentation/pages/sign_in_page.dart';
import 'features/authentication/presentation/pages/sign_up_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eCommerce App',
        theme: ThemeData(
          primaryColor: const Color(0XFF3F51F3),
          hintColor: Colors.green.shade600,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/sign-in': (context) => BlocProvider(create: (_) => di.sl<AuthBloc>(), child: const SignInPage()),
          '/sign-up': (context) => BlocProvider(create: (_) => di.sl<AuthBloc>(), child: const SignUpPage()),
          '/home': (context) => BlocProvider(create: (_) => di.sl<AuthBloc>(), child: const HomeScreen()),
        },
      ),
    );
  }
}
