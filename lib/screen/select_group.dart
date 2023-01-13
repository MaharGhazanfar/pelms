import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/ModelFeeStructure.dart';
import '../provider/model_create_group.dart';
import '../util/firebase_db_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../widget/custom_check_box.dart';

class CourseEnrollment extends StatefulWidget {
  final List<String>? userStatus;

  const CourseEnrollment({Key? key, required this.userStatus})
      : super(key: key);
  static const pageName = '/SelectGroup';

  @override
  _CourseEnrollmentState createState() => _CourseEnrollmentState();
}

class _CourseEnrollmentState extends State<CourseEnrollment> {
  late Stream<QuerySnapshot> _selectCourseStream;

  late List<bool> itemStatus = [];
  bool check = true;
  late SharedPreferences prefs;
  DateTime dateToday = DateTime.now();

  @override
  void initState() {
    super.initState();
    print('..................../${widget.userStatus}......');

    widget.userStatus.toString().contains('SuperAdmin')
        ? _selectCourseStream = DBHandler.groupCollection().snapshots()
        : _selectCourseStream =
            DBHandler.groupCollectionWithUID(widget.userStatus![2].toString())
                .snapshots();
    studentCourseEnrollment();
  }

  Future<List<bool>> getStatus() async {
    if (check) {
      await studentCourseEnrollment();
      if (widget.userStatus.toString().contains('SuperAdmin')) {
        var snapGroup = await DBHandler.groupCollection().get();
        int groupLength = snapGroup.docs.length;
        for (int status = 0; status < groupLength; status++) {
          itemStatus.add(false);
        }
        //The Students enrolled the courses to be sets true
        if (prefs.containsKey('cnic')) {
          var coursesSnap = await DBHandler.studentCourseEnrollmentCollection(
                  prefs.getString('cnic')!)
              .get();
          int coursesLength = coursesSnap.docs.length;

          for (int courseStatus = 0;
              courseStatus < coursesLength;
              courseStatus++) {
            for (int status = 0; status < groupLength; status++) {
              if (coursesSnap.docs.elementAt(courseStatus).id ==
                  snapGroup.docs.elementAt(status).id) {
                itemStatus[status] = true;
              }
            }
          }
        }
      } else {
        var snapGroup = await DBHandler.groupCollectionWithUID(
                widget.userStatus![2].toString())
            .get();
        int groupLength = snapGroup.docs.length;
        for (int status = 0; status < groupLength; status++) {
          itemStatus.add(false);
        }
        //The Students enrolled the courses to be sets true
        if (prefs.containsKey('cnic')) {
          var coursesSnap =
              await DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                      prefs.getString('cnic')!,
                      widget.userStatus![2].toString())
                  .get();
          int coursesLength = coursesSnap.docs.length;

          for (int courseStatus = 0;
              courseStatus < coursesLength;
              courseStatus++) {
            for (int status = 0; status < groupLength; status++) {
              if (coursesSnap.docs.elementAt(courseStatus).id ==
                  snapGroup.docs.elementAt(status).id) {
                itemStatus[status] = true;
              }
            }
          }
        }
      }

      check = false;
    }
    return itemStatus;
  }

  Future<CollectionReference?>? studentCourseEnrollment() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('cnic')) {
      if (widget.userStatus.toString().contains('SuperAdmin')) {
        return DBHandler.studentCourseEnrollmentCollection(
            prefs.getString('cnic')!);
      } else {
        return DBHandler.studentCourseEnrollmentCollectionWithUserUID(
            prefs.getString('cnic')!, widget.userStatus![2]);
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newTheme = theme.checkboxTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Your Courses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: getStatus(),
          builder: (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: kIsWeb
                      ? MediaQuery.of(context).size.width * 0.6
                      : MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _selectCourseStream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          // if (check) {
                          //   getStatus(snapshot.data!.docs.length);
                          //   check = false;
                          // }
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var singleGroupInfo =
                                    snapshot.data!.docs[index];

                                void onChangedValue(bool? value) async {
                                  if (prefs.containsKey('cnic')) {
                                    if (value!) {
                                      var feeStructure = ModelFeeStructure(
                                          title: singleGroupInfo[
                                              ModelCreateGroup.groupNameKey],
                                          payableInstallment: [],
                                          maxInstallment: int.parse(
                                              singleGroupInfo[ModelCreateGroup
                                                  .durationKey]),
                                          minInstallment: 0,
                                          payable: double.parse(
                                            singleGroupInfo[ModelCreateGroup
                                                    .courseFeeKey]
                                                .toString(),
                                          ),
                                          paidStatus: [],
                                          outStanding: [],
                                          date: dateToday
                                              .toString()
                                              .substring(0, 10));

                                      var courseEnrollmentCOll =
                                          await studentCourseEnrollment();

                                      courseEnrollmentCOll!
                                          .doc(singleGroupInfo[
                                              ModelCreateGroup.groupNameKey])
                                          .set(feeStructure.toMap());

                                      if (widget.userStatus
                                          .toString()
                                          .contains('SuperAdmin')) {
                                        Map<String, dynamic> studentData =
                                            await DBHandler.studentCollection()
                                                .doc(prefs.getString('cnic'))
                                                .get()
                                                .then((DocumentSnapshot
                                                    documentSnapshot) {
                                          return documentSnapshot.data()
                                              as Map<String, dynamic>;
                                        });

                                        DBHandler.groupStudentCollection(
                                                singleGroupInfo[ModelCreateGroup
                                                    .groupNameKey])
                                            .doc(prefs.getString('cnic'))
                                            .set(studentData);
                                      } else {
                                        Map<String, dynamic> studentData =
                                            await DBHandler
                                                    .studentCollectionWithUID(
                                                        widget.userStatus![2]
                                                            .toString())
                                                .doc(prefs.getString('cnic'))
                                                .get()
                                                .then((DocumentSnapshot
                                                    documentSnapshot) {
                                          return documentSnapshot.data()
                                              as Map<String, dynamic>;
                                        });

                                        DBHandler.groupStudentCollectionWithUID(
                                                singleGroupInfo[ModelCreateGroup
                                                    .groupNameKey],
                                                widget.userStatus![2]
                                                    .toString())
                                            .doc(prefs.getString('cnic'))
                                            .set(studentData);
                                      }
                                    } else {
                                      var deleteCourse =
                                          await studentCourseEnrollment();
                                      deleteCourse!
                                          .doc(singleGroupInfo[
                                              ModelCreateGroup.groupNameKey])
                                          .delete();

                                      if (widget.userStatus
                                          .toString()
                                          .contains('SuperAdmin')) {
                                        DBHandler.groupStudentCollection(
                                                singleGroupInfo[ModelCreateGroup
                                                    .groupNameKey])
                                            .doc(prefs.getString('cnic'))
                                            .delete();
                                      } else {
                                        DBHandler.groupStudentCollectionWithUID(
                                                singleGroupInfo[ModelCreateGroup
                                                    .groupNameKey],
                                                widget.userStatus![2])
                                            .doc(prefs.getString('cnic'))
                                            .delete();
                                      }
                                    }
                                    setState(() {
                                      itemStatus[index] = value;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Please Add the Student First')));
                                  }
                                }

                                return Theme(
                                  data: theme.copyWith(checkboxTheme: newTheme),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CheckBoxWidget.customCheckBoxTile(
                                      status: itemStatus[index],
                                      icon: Icons.menu_book_rounded,
                                      title: singleGroupInfo[
                                          ModelCreateGroup.groupNameKey],
                                      onChangedValue: onChangedValue,
                                    ),
                                  ),
                                );
                              });
                        }
                      }),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
