import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 41,),
            // Name Field
            Text(
              'Name',
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
                decoration: InputDecoration(
                  hintText: 'ex: John Smith',
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

            // Email Field
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
                decoration: InputDecoration(
                  hintText: 'ex: jon.smith@email.com',
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
            // Password Field
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
                //  to make the password
                // obscuringCharacter: '*',
                // obscureText: true,
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

            // Confirm Password
            Text(
              'Confirm Password',
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
                //  to make the password
                // obscuringCharacter: '*',
                // obscureText: true,
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
          ],
        ),
      ),
    );

  }
}