import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../injection_container.dart';
import '../../bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.of(context).pushReplacementNamed('/sign-in');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBody(context));
  }


  BlocProvider<AuthBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => sl<AuthBloc>(),
      child: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/image.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            // Alpha: 77 (30% opacity)
            color: const Color(0xFF3F51F3).withValues(alpha: 77),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Positioned(
                  top: 279,
                  left: 63,
                  child: Container(
                    width: 264,
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(31),
                      color: Colors.white,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'ECOM',
                        style: GoogleFonts.caveatBrush(
                          fontSize: 120,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2.0,
                          color: const Color(0xFF3F51F3)
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Positioned(
                  top: 426,
                  left: 39,
                  child: Text(
                    'ECOMMERCE APP',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
