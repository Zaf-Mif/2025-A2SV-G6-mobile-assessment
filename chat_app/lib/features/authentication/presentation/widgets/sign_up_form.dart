import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSignUpPressed;
  final bool isLoading;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSignUpPressed,
    this.isLoading = false,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  // bool _obscurePassword = true;
  // bool _obscureConfirmPassword = true;

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSignUpPressed();
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
            const SizedBox(height: 41),

            // Name Field
            Text(
              'Name',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: 288,
              height: 42,
              child: TextFormField(
                controller: widget.nameController,
                validator: _validateName,
                decoration: InputDecoration(
                  hintText: 'ex: John Smith',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 13),

            // Email Field
            Text(
              'Email',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: 288,
              height: 42,
              child: TextFormField(
                controller: widget.emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'ex: jon.smith@email.com',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 13),

            // Password Field
            Text(
              'Password',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: 288,
              height: 42,
              child: TextFormField(
                controller: widget.passwordController,
                // obscureText: _obscurePassword,
                validator: _validatePassword,
                decoration: InputDecoration(
                  hintText: '*********',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _obscurePassword = !_obscurePassword;
                  //     });
                  //   },
                  // ),
                ),
              ),
            ),

            const SizedBox(height: 13),

            // Confirm Password Field
            Text(
              'Confirm Password',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: 288,
              height: 42,
              child: TextFormField(
                controller: widget.confirmPasswordController,
                // obscureText: _obscureConfirmPassword,
                validator: _validateConfirmPassword,
                decoration: InputDecoration(
                  hintText: '*********',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  // suffixIcon: IconButton(
                    // icon: Icon(
                      // _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      // color: Colors.grey,
                    // ),
                    // onPressed: () {
                    //   setState(() {
                    //     _obscureConfirmPassword = !_obscureConfirmPassword;
                    //   });
                    // },
                  // ),
                ),
              ),
            ),

            const SizedBox(height: 20),

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
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'SIGN UP',
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
