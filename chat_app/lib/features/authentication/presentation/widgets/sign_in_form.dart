import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final bool isLoading;

  const SignInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    this.isLoading = false,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final gmailRegex = RegExp(r'^[\w-\.]+@gmail\.com$');
    if (!gmailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid Gmail address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onLoginPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email Field Label
            Text(
              'Email',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 13),

            SizedBox(
              width: 288,
              height: 42,
              child: TextFormField(
                controller: widget.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                decoration: InputDecoration(
                  hintText: 'ex: jon.smith@gmail.com',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                  fillColor: const Color(0x00fafafa),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 13),

            // Password Field Label
            Text(
              'Password',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 13),

            SizedBox(
              width: 288,
              height: 42,
              child: TextFormField(
                controller: widget.passwordController,
                // obscuringCharacter: '*',
                // obscureText: true,
                validator: _validatePassword,
                decoration: InputDecoration(
                  hintText: '*********',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                  fillColor: const Color(0x00fafafa),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 37),

            SizedBox(
              width: 288,
              height: 42,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'SIGN IN',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
