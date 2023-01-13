import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/model_user_login.dart';
import '../../util/firebase_db_handler.dart';
import '../../util/network_authentication.dart';
import '../../util/validation.dart';
import '../../widget/bnb_for_student_detail.dart';
import '../../widget/custom_button.dart';
import '../dashboard.dart';

class UserRegistration extends StatefulWidget {
  final String userCNIC;
  final String superAdminsUID;
  final String userStatus;

  const UserRegistration(
      {required this.superAdminsUID,
      required this.userCNIC,
      Key? key,
      required this.userStatus})
      : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  final globalUserRegistrationKey = GlobalKey<FormState>();
  ButtonState stateTextWithIcon = ButtonState.idle;
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  IconData eyeIcon = Icons.visibility_off;

  void inContact(TapDownDetails details) {
    setState(() {
      _obscured = false;
      eyeIcon = Icons.visibility;
    });
  }

  void outContact(TapUpDetails details) {
    setState(() {
      _obscured = true;
      eyeIcon = Icons.visibility_off;
    });
  }

  @override
  void dispose() {
    userPasswordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width > 500
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          //color: Colors.red,
                          image: DecorationImage(
                              image: AssetImage('assets/verification_page.png'),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: globalUserRegistrationKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                validator: (value) {
                                  return ModelValidation.gmailValidation(
                                      value.toString());
                                },
                                onChanged: (value) {
                                  setState(() {
                                    stateTextWithIcon = ButtonState.idle;
                                  });
                                },
                                controller: userNameController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person),
                                    labelText: 'EmailAddress',
                                    focusColor: Colors.blue,
                                    fillColor: Colors.white,
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 1)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: TextFormField(
                                  validator: (value) {
                                    return ModelValidation.passwordValidation(
                                        value.toString());
                                  },
                                  controller: userPasswordController,
                                  onChanged: (value) {
                                    setState(() {
                                      stateTextWithIcon = ButtonState.idle;
                                    });
                                  },
                                  maxLength: 8,
                                  obscureText: _obscured,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTapDown: inContact,
                                        //call this method when incontact
                                        onTapUp: outContact,
                                        //call this method when contact with screen is removed
                                        child: Icon(eyeIcon),
                                      ),
                                      prefixIcon: const Icon(Icons.key),
                                      labelText: 'Password',
                                      focusColor: Colors.blue,
                                      fillColor: Colors.white,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: 1)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: CustomButton(
                                    onPressed: () {
                                      onPressedIconWithText(context);
                                    },
                                    buttonState: stateTextWithIcon,
                                    text: 'Register',
                                  ))
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> registration() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text.toString().trim(),
          password: userPasswordController.text.toString().trim());

      return 'registered';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email';
      }
    } catch (e) {
      return 'Registered Failed';
    }
    return 'SomeThings Went Wrong';
  }

  void onPressedIconWithText(BuildContext mainContext) {
    NetworkAuth.check().then((internet) async {
      if (internet) {
        switch (stateTextWithIcon) {
          case ButtonState.idle:
            {
              if (globalUserRegistrationKey.currentState!.validate()) {
                setState(() {
                  stateTextWithIcon = ButtonState.loading;
                });
                print(
                    '.................registeredButtonclick....................');
                print(
                    '.................${widget.userStatus}....................');
                print(
                    '.................${widget.superAdminsUID}....................');
                print(
                    '.................${widget.userCNIC}....................');

                ///////////////////////////Admin//////////////////////////////////////////////

                if (widget.userStatus == 'Admin') {
                  var adminLoginInfo = ModelUserLogin(
                      userName: userNameController.text.toString(),
                      password: userPasswordController.text.toString());

                  DBHandler.adminCollectionRegistrationWithUID(
                          widget.superAdminsUID)
                      .doc(widget.userCNIC)
                      .set(adminLoginInfo.toMap())
                      .then((value) async {
                    print('SUCCESS');
                    var loginStatus = await registration();

                    if (loginStatus == 'registered') {
                      SharedPreferences share =
                          await SharedPreferences.getInstance();
                      share.remove('getUserInfo');
                      share.setStringList('getUserInfo', [
                        widget.userStatus,
                        widget.userCNIC,
                        widget.superAdminsUID,
                      ]);
                      setState(() {
                        stateTextWithIcon = ButtonState.success;
                      });
                      await Future.delayed(const Duration(seconds: 1))
                          .then((value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyDashBoard(
                                        userStatus: widget.userStatus,
                                      )),
                              (route) => false));
                    } else {
                      setState(() {
                        stateTextWithIcon = ButtonState.fail;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('SomeThing went wrong')));
                    }
                  }).onError((error, stackTrace) {
                    setState(() {
                      print('FAILED');
                    });
                  });
                } //////////////////////////////////////////////////  Student/////////////////////////

                if (widget.userStatus == 'Student') {
                  print(
                      '.................registeredStudent....................');
                  var studentLoginInfo = ModelUserLogin(
                      userName: userNameController.text.toString(),
                      password: userPasswordController.text.toString());

                  DBHandler.studentRegistrationWithUID(widget.superAdminsUID)
                      .doc(widget.userCNIC)
                      .set(studentLoginInfo.toMap())
                      .then((value) async {
                    print('SUCCESS');
                    var loginStatus = await registration();

                    if (loginStatus == 'registered') {
                      SharedPreferences share =
                          await SharedPreferences.getInstance();
                      share.remove('getUserInfo');

                      share.setStringList('getUserInfo', [
                        widget.userStatus,
                        widget.userCNIC,
                        widget.superAdminsUID,
                      ]);
                      setState(() {
                        stateTextWithIcon = ButtonState.success;
                      });
                      await Future.delayed(const Duration(seconds: 1))
                          .then((value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BNBForStudentProfile(
                                    userStatus: widget.userStatus,
                                    userUID: widget.superAdminsUID,
                                    userCnic: widget.userCNIC),
                              ),
                              (route) => false));
                    } else {
                      setState(() {
                        stateTextWithIcon = ButtonState.fail;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('SomeThing went wrong')));
                      print(loginStatus);
                    }
                  }).onError((error, stackTrace) {
                    setState(() {
                      print('FAILED');
                    });
                  });
                }
              }

              break;
            }

          case ButtonState.loading:
            break;
          case ButtonState.success:
            stateTextWithIcon = ButtonState.idle;
            break;
          case ButtonState.fail:
            stateTextWithIcon = ButtonState.idle;
            break;
        }
        setState(() {
          stateTextWithIcon = stateTextWithIcon;
        });
      } else {
        NetworkAuth.showNow(mainContext);
      }
    });
  }
}
