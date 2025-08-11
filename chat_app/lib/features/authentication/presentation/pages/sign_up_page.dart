import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new, color:Color(0XFF3F51F3),),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 33.0),
            child: Container(
              width: 60,
              height: 25,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.41),
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFF3F51F3),
                width: 0.93,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'ECOM',
                style: GoogleFonts.caveatBrush(
                  fontSize: 50,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                  color: const Color(0xFF3F51F3)
                ),
              ),
            ),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 51),
            Positioned(
              top: 154,
              left: 50,
              child: Text(
                'Create your account',
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SignUpForm(), // call the sign up form widget
            
            const SizedBox(height: 21),
            SizedBox(
              width: 288,
              height: 42,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
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
            const SizedBox(height: 152),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account? ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/sign-in'); // go to sign-in page
                  },
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                      color: Color(0xff3F51F3),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
