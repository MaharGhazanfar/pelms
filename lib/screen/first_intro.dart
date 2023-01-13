import 'package:flutter/material.dart';
import 'package:pelms/screen/user_verification/user_verification.dart';
import 'package:rive/rive.dart';

import 'login_screen.dart';

class FirstIntro extends StatefulWidget {
  const FirstIntro({Key? key}) : super(key: key);
  static const pageName = '/FirstIntro';

  @override
  State<FirstIntro> createState() => _FirstIntroState();
}

class _FirstIntroState extends State<FirstIntro> {
  late RiveAnimationController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'flip',
      autoplay: true,
      onStop: () => setState(() => isPlaying = false),
      onStart: () => setState(() => isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        RiveAnimation.asset(
          'assets/book_flip.riv',
          fit: BoxFit.fill,
          controllers: [_controller],
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          top: MediaQuery.of(context).size.height * .65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        )),
                    child: getButton(name: 'Super Admin')),
              )),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const VerificationUserCNIC(userStatus: 'Admin'),
                          ));
                    },
                    child: getButton(name: 'Admin')),
              )),
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VerificationUserCNIC(
                                userStatus: 'Student'),
                          ));
                    },
                    child: getButton(name: 'Student')),
              ))
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text('Powered By CAS'),
          ),
        )
      ],
    ));
  }

  Widget getButton({required String name}) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 2),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.black12, width: 3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, offset: Offset(-3, 3))
                ]),
            alignment: Alignment.center,
            child: Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
