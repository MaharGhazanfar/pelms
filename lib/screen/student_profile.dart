import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../provider/model_add_student.dart';
import '../util/firebase_db_handler.dart';
import '../widget/custom_profile.dart';
import 'first_intro.dart';

class StudentProfile extends StatefulWidget {
  final String studentCnic;
  final String userStatus;
  final String userUID;

  const StudentProfile(
      {Key? key,
      required this.userStatus,
      required this.studentCnic,
      required this.userUID})
      : super(key: key);
  static const pageName = '/StudentProfile';

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  Map<String, dynamic>? personalInfo;

  @override
  void initState() {
    super.initState();
    print('................${widget.userUID}');
  }

  Future<Map<String, dynamic>> studentInfo() async {
    return await DBHandler.studentCollectionWithUID(widget.userUID)
        .doc(widget.studentCnic)
        .get()
        .then((DocumentSnapshot document) {
      return document.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Student Details'),
        actions: [
          widget.userStatus.contains('Student')
              ? IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FirstIntro(),
                        ),
                        (route) => false);
                    FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
                  },
                  icon: const Icon(Icons.logout))
              : const SizedBox()
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: kIsWeb
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: studentInfo(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                        'Something went wrong////////////////////////////////////////////////////');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {},
                          child: const CircleAvatar(
                            child: Icon(Icons.person),
                            radius: 30,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomProfileWidget.customProfileText(
                              title: 'Name',
                              text: snapshot.data[ModelAddStudent.nameKey],
                              context: context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomProfileWidget.customProfileText(
                            title: 'FatherName',
                            text: snapshot.data[ModelAddStudent.fatherNameKey],
                            context: context,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomProfileWidget.customProfileText(
                            title: 'PhoneNumber',
                            text: snapshot.data[ModelAddStudent.phoneNumberKey],
                            context: context,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomProfileWidget.customProfileText(
                            title: 'CNIC',
                            text: snapshot.data[ModelAddStudent.cnicKey],
                            context: context,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomProfileWidget.customProfileText(
                            title: 'Gmail',
                            text: snapshot.data[ModelAddStudent.gMailKey],
                            context: context,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomProfileWidget.customProfileText(
                            title: 'Gender',
                            text: snapshot.data[ModelAddStudent.genderKey],
                            context: context,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            // height: 50,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(
                                        2,
                                        2,
                                      ),
                                      spreadRadius: 3,
                                      blurRadius: 3)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width <=
                                                    400
                                                ? 15
                                                : 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.65)),
                                  ),
                                  Text(
                                    ' : ',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width <=
                                                    400
                                                ? 16
                                                : 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black.withOpacity(0.65)),
                                  ),
                                  Flexible(
                                    child: Text(
                                      snapshot.data[ModelAddStudent.addressKey],
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width <=
                                                  400
                                              ? 15
                                              : 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //CustomProfileWidget.customProfileText(text: snapshot.data[ModelAddStudent.addressKey] , title: 'Address', context: context),
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
