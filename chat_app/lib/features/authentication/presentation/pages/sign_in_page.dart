import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/sign_in_form.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    context.read<AuthBloc>().add(SignInEvent(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 122),

                  // Logo
                  Container(
                    width: 144,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF3F51F3), width: 0.93),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'ECOM',
                        style: GoogleFonts.caveatBrush(
                          fontSize: 120,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2.0,
                          color: const Color(0xFF3F51F3),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Title
                  Text(
                    'Sign into your account',
                    style: GoogleFonts.poppins(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 51),

                  // SignInForm with validation & loading
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SignInForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        onLoginPressed: _onLoginPressed,
                        isLoading: state is AuthLoading,
                      );
                    },
                  ),

                  const SizedBox(height: 152),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/sign-up');
                        },
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: Color(0xff3F51F3),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
