import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import '../util/firebase_authentication.dart';
import '../util/firebase_db_handler.dart';

class LoginScreen extends StatelessWidget {
  static const pageName = '/Login';

  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    const inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );
    return FlutterLogin(
      navigateBackAfterRecovery: true,
      onRecoverPassword: LoginAuthentication.recoverPassword,
      onLogin: LoginAuthentication.authUser,
      onSignup: LoginAuthentication.signupUser,
      loginProviders: const <LoginProvider>[
        // LoginProvider(
        //   icon: FontAwesomeIcons.google,
        //   callback: () async {
        //    // await LoginAuthentication.signInWithGoogle();
        //     return 'This feature is not available';
        //   },
        // ),
      ],
      onSubmitAnimationCompleted: () {
        FirebaseFirestore.instance
            .collection('SuperAdmins')
            .doc(DBHandler.user!.uid.toString())
            .set({'Email': DBHandler.user!.email.toString()});
        Navigator.pop(context);
      },
      theme: LoginTheme(
        primaryColor: Colors.blue.shade100,
        titleStyle: const TextStyle(
          color: Colors.blue,
          letterSpacing: 4,
        ),
        bodyStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        textFieldStyle: const TextStyle(
          color: Colors.black,
        ),
        buttonStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.yellow,
        ),
        cardTheme: CardTheme(
          shadowColor: Colors.blue.shade100,
          color: Colors.blueGrey.shade200,
          elevation: 8,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.indigo.withOpacity(.4),
          contentPadding: EdgeInsets.zero,
          errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.black),
          labelStyle: const TextStyle(fontSize: 12, color: Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
            borderRadius: inputBorder,
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 5),
            borderRadius: inputBorder,
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 7),
            borderRadius: inputBorder,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800, width: 8),
            borderRadius: inputBorder,
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 5),
            borderRadius: inputBorder,
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.purple,
          backgroundColor: Colors.blue.shade400,
          highlightColor: Colors.lightGreen,
          elevation: 6.0,
          highlightElevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          //
        ),
      ),
    );
  }
}
