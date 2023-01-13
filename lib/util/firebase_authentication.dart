import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAuthentication {
  static Future<String?> signupUser(SignupData data) async {
    try {
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: data.name!,
      //   password: data.password!,
      // );
      // SharedPreferences share = await SharedPreferences.getInstance();
      // share.remove('getUserInfo');
      // share.setStringList('getUserInfo', ['SuperAdmin']);

      return 'THis feature is not available';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return 'Sign Up Failed';
    }
    return null;
  }

  static Future<String?> recoverPassword(String name) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
    return null;
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    SharedPreferences share = await SharedPreferences.getInstance();
    share.remove('getUserInfo');
    share.setStringList('getUserInfo', ['SuperAdmin']);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<String?> authUser(LoginData data) async {
    try {
      SharedPreferences share = await SharedPreferences.getInstance();
      share.remove('getUserInfo');
      share.setStringList('getUserInfo', ['SuperAdmin']);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name, password: data.password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        print('${e.code}//////////////////////////////');
        return 'No internet Connection found';
      }
    }
  }
}
