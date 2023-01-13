import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:pelms/screen/user_verification/user_login.dart';
import 'package:pelms/screen/user_verification/user_registiration.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../util/firebase_db_handler.dart';
import '../../util/network_authentication.dart';
import '../../util/validation.dart';
import '../../widget/custom_button.dart';

class VerificationUserCNIC extends StatefulWidget {
  final String userStatus;

  const VerificationUserCNIC({Key? key, required this.userStatus})
      : super(key: key);

  @override
  _VerificationUserCNICState createState() => _VerificationUserCNICState();
}

class _VerificationUserCNICState extends State<VerificationUserCNIC> {
  late TextEditingController userVerficationController;

  final globalUserVerificationKey = GlobalKey<FormFieldState>();
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  void initState() {
    super.initState();
    userVerficationController = TextEditingController();
    userVerficationController.addListener(() {
      setState(() {
        stateTextWithIcon = ButtonState.idle;
      });
    });
  }

  @override
  void dispose() {
    userVerficationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 500
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/verification_page.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              Flexible(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          key: globalUserVerificationKey,
                          onChanged: (value) {
                            stateTextWithIcon = ButtonState.idle;
                          },
                          validator: (value) =>
                              ModelValidation.cnicValidation(value.toString()),
                          inputFormatters: [
                            MaskedInputFormatter('#####-#######-#',
                                allowedCharMatcher: RegExp(r'[0-9]'))
                          ],
                          maxLength: 15,
                          keyboardType: TextInputType.number,
                          controller: userVerficationController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.perm_identity),
                              labelText: 'CNIC',
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
                            child: CustomButton(
                              buttonState: stateTextWithIcon,
                              onPressed: () {
                                onPressedIconWithText(context);
                              },
                              text: 'Verification',
                            ))
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void onPressedIconWithText(BuildContext mainContext) {
    NetworkAuth.check().then((internet) async {
      if (internet) {
        switch (stateTextWithIcon) {
          case ButtonState.idle:
            {
              if (globalUserVerificationKey.currentState!.validate()) {
                setState(() {
                  stateTextWithIcon = ButtonState.loading;
                });
                print('..............buttomclick.............................');
                var superAdminsDocs = await FirebaseFirestore.instance
                    .collection('SuperAdmins')
                    .get();
                print(
                    '..............getaDMINsdocs.. ...........................');

                if (widget.userStatus == 'Admin') {
                  var wholeAdminCollection =
                      await DBHandler.adminCollectionWithUID(
                              superAdminsDocs.docs[0].id)
                          .get();

                  Set adminCNICForVerification =
                      wholeAdminCollection.docs.map((document) {
                    if (document.id ==
                        userVerficationController.text.toString()) {
                      return document.id;
                    }
                  }).toSet();

                  if (adminCNICForVerification.contains(
                      userVerficationController.text.toString().trim())) {
                    print('..............verify.............................');
                    var registeredAdmin =
                        await DBHandler.adminCollectionRegistrationWithUID(
                                superAdminsDocs.docs[0].id)
                            .get();

                    if (registeredAdmin.docs.isNotEmpty) {
                      Set adminRegistrationCheck =
                          registeredAdmin.docs.map((document) {
                        if (document.id ==
                            userVerficationController.text.toString()) {
                          return document.id;
                        }
                      }).toSet();

                      if (adminRegistrationCheck.contains(
                          userVerficationController.text.toString())) {
                        print('.............userLogin...........');
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                        await Future.delayed(const Duration(seconds: 1))
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserLogin(
                                    userUID:
                                        superAdminsDocs.docs[0].id.toString(),
                                    userCnic: userVerficationController.text
                                        .toString(),
                                    userStatus: 'Admin',
                                  ),
                                )));
                      } else {
                        print('.............userRegistration...........');
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                        await Future.delayed(const Duration(seconds: 1))
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserRegistration(
                                    superAdminsUID:
                                        superAdminsDocs.docs[0].id.toString(),
                                    userCNIC: userVerficationController.text
                                        .toString()
                                        .trim(),
                                    userStatus: 'Admin',
                                  ),
                                )));
                      }
                    } else {
                      print('.............userRegistration...........');
                      setState(() {
                        stateTextWithIcon = ButtonState.success;
                      });
                      await Future.delayed(const Duration(seconds: 1))
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserRegistration(
                                  superAdminsUID:
                                      superAdminsDocs.docs[0].id.toString(),
                                  userCNIC: userVerficationController.text
                                      .toString()
                                      .trim(),
                                  userStatus: 'Admin',
                                ),
                              )));
                    }
                  } else {
                    setState(() {
                      stateTextWithIcon = ButtonState.fail;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('There is no Admin for this CNIC')));
                    print('There is no Admin for this CNIC');
                  }
                }
                ///////////////////////////////////////////////student//////////////////////////////////

                if (widget.userStatus == 'Student') {
                  print(
                      '.................student....${superAdminsDocs.docs[0].id}..................');
                  var wholeStudentCollection =
                      await DBHandler.studentCollectionWithUID(
                              superAdminsDocs.docs[0].id)
                          .get();

                  Set studentCNICForVerification =
                      wholeStudentCollection.docs.map((document) {
                    if (document.id ==
                        userVerficationController.text.toString()) {
                      return document.id;
                    }
                  }).toSet();

                  if (studentCNICForVerification.contains(
                      userVerficationController.text.toString().trim())) {
                    print('..............verify.............................');
                    var registeredStudent =
                        await DBHandler.studentRegistrationWithUID(
                                superAdminsDocs.docs[0].id)
                            .get();

                    if (registeredStudent.docs.isNotEmpty) {
                      Set studentRegistrationCheck =
                          registeredStudent.docs.map((document) {
                        if (document.id ==
                            userVerficationController.text.toString()) {
                          return document.id;
                        }
                      }).toSet();

                      if (studentRegistrationCheck.contains(
                          userVerficationController.text.toString())) {
                        print('.............userLogin...........');
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                        await Future.delayed(const Duration(seconds: 1))
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserLogin(
                                    userUID:
                                        superAdminsDocs.docs[0].id.toString(),
                                    userCnic: userVerficationController.text
                                        .toString(),
                                    userStatus: 'Student',
                                  ),
                                )));
                      } else {
                        print('.............userRegistration...........');
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                        await Future.delayed(const Duration(seconds: 1))
                            .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserRegistration(
                                    superAdminsUID:
                                        superAdminsDocs.docs[0].id.toString(),
                                    userCNIC: userVerficationController.text
                                        .toString()
                                        .trim(),
                                    userStatus: 'Student',
                                  ),
                                )));
                      }
                    } else {
                      print('.............userRegistration...........');
                      setState(() {
                        stateTextWithIcon = ButtonState.success;
                      });
                      await Future.delayed(const Duration(seconds: 1))
                          .then((value) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserRegistration(
                                  superAdminsUID:
                                      superAdminsDocs.docs[0].id.toString(),
                                  userCNIC: userVerficationController.text
                                      .toString()
                                      .trim(),
                                  userStatus: 'Student',
                                ),
                              )));
                    }
                  } else {
                    setState(() {
                      stateTextWithIcon = ButtonState.fail;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('There is no Student for this CNIC')));

                    print('There is no student for this CNIC');
                  }
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
