import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pelms/provider/carousel_counter.dart';
import 'package:pelms/provider/model_add_student.dart';
import 'package:pelms/screen/dashboard.dart';
import 'package:pelms/screen/first_intro.dart';
import 'package:pelms/util/item_select_check.dart';
import 'package:pelms/util/item_select_check_for_students.dart';
import 'package:pelms/widget/bnb_for_student_detail.dart';
import 'package:provider/provider.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigation/route_configration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBLCRgHOhATI3KHUbyuoWrUtV-RL67GBEQ",
            authDomain: "elms-1f615.firebaseapp.com",
            projectId: "elms-1f615",
            storageBucket: "elms-1f615.appspot.com",
            messagingSenderId: "807660672566",
            appId: "1:807660672566:web:62aaf4f9e84d97f1a02a97",
            measurementId: "G-MFZFL175HZ"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CarouselCounter>(
          create: (context) => CarouselCounter(),
        ),
        ChangeNotifierProvider<ModelAddStudent>(
          create: (context) => ModelAddStudent(),
        ),
        ChangeNotifierProvider<SelectMultipleItems>(
          create: (context) => SelectMultipleItems(),
        ),
        ChangeNotifierProvider<SelectMultipleItemsForStudent>(
          create: (context) => SelectMultipleItemsForStudent(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: RouteConfiguration.generateRouts,
        home: SplashScreen.navigate(
          backgroundColor: Colors.blue.shade300,
          name: 'assets/boy.riv',
          next: (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot<User?> userSnapshot) {
                if (userSnapshot.hasData) {
                  print(
                      '.........................login...................................');
                  return FutureBuilder(
                    future: SharedPreferences.getInstance()
                        .then((value) => value.getStringList('getUserInfo')),
                    builder: (context,
                        AsyncSnapshot<List<String>?> sharePrefSnapshot) {
                      if (sharePrefSnapshot.hasData) {
                        print(
                            '....................................getsnapshot..................................');

                        List<String>? info = sharePrefSnapshot.data;

                        if (info!.contains('SuperAdmin')) {
                          print(
                              '.............................superadmin.....................');
                          return MyDashBoard(
                            userStatus: info[0],
                          );
                        } else if (info.contains('Student')) {
                          print(
                              '..........................student.........................');
                          return BNBForStudentProfile(
                            userStatus: info[0],
                            userCnic: info[1],
                            userUID: info[2],
                          );
                        } else {
                          print(
                              '..........................else not .........................');
                          return MyDashBoard(
                            userStatus: info[0],
                          );
                        }
                      } else {
                        print(
                            '........................else......................');
                        return const MyDashBoard(
                          userStatus: 'SuperAdmin',
                        );
                      }
                    },
                  );
                } else {
                  print(
                      '.......................signout..........................');
                  return const FirstIntro();
                }
              }),
          startAnimation: 'SayHi',
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            Tween<Offset> tween = Tween<Offset>(
                begin: const Offset(0, 1), end: const Offset(0, 0));
            return SlideTransition(
              position: tween.animate(animation),
              child: child,
            );
          },
          until: () => Future.delayed(const Duration(seconds: 1)),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
