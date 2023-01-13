import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../provider/ModelFeeStructure.dart';
import '../util/firebase_db_handler.dart';
import '../widget/custom_profile.dart';

class AcademicDetailsForStudent extends StatefulWidget {
  final String cnic;
  final String userUID;

  const AcademicDetailsForStudent(
      {Key? key, required this.cnic, required this.userUID})
      : super(key: key);

  @override
  _AcademicDetailsForStudentState createState() =>
      _AcademicDetailsForStudentState();
}

class _AcademicDetailsForStudentState extends State<AcademicDetailsForStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Academic Details '),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                      widget.cnic, widget.userUID)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshotData) {
                if (snapshotData.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshotData.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshotData.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshotData.data!.docs.length,
                    itemBuilder: (context, index) {
                      var singleCourseFeeInfo = snapshotData.data!.docs[index];
                      String currentDate =
                          singleCourseFeeInfo[ModelFeeStructure.dateKey];
                      var datePicker = DateTime(
                          int.parse(currentDate.substring(0, 4)),
                          int.parse(currentDate.substring(6, 7)),
                          int.parse(currentDate.substring(9, 10)));
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomProfileWidget.customProfileText(
                                  text: singleCourseFeeInfo[
                                      ModelFeeStructure.titleKey],
                                  title: 'Course Name',
                                  context: context),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomProfileWidget.customProfileText(
                                  text: singleCourseFeeInfo[
                                          ModelFeeStructure.payableKey]
                                      .toString(),
                                  title: 'Total Fee ',
                                  context: context),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                    defaultColumnWidth:
                                        const FixedColumnWidth(100),
                                    border: TableBorder.all(
                                        color: Colors.blue.shade600),
                                    children: List.generate(
                                      singleCourseFeeInfo[ModelFeeStructure
                                              .minInstallmentKey] +
                                          1,
                                      (index) => TableRow(children: [
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              index == 0
                                                  ? ModelFeeStructure.titleKey
                                                  : '${singleCourseFeeInfo[ModelFeeStructure.titleKey]}',
                                              style: index == 0
                                                  ? const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : const TextStyle(
                                                      fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              index == 0
                                                  ? ModelFeeStructure.payableKey
                                                      .toString()
                                                  : singleCourseFeeInfo[
                                                              ModelFeeStructure
                                                                  .payableInstallmentKey]
                                                          [index - 1]
                                                      .toString(),
                                              style: index == 0
                                                  ? const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : const TextStyle(
                                                      fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              index == 0
                                                  ? ModelFeeStructure.dateKey
                                                  : DateTime(
                                                          datePicker.year,
                                                          datePicker.month +
                                                              (index - 1),
                                                          index < 2
                                                              ? datePicker.day
                                                              : 05)
                                                      .toString()
                                                      .substring(0, 10),
                                              style: index == 0
                                                  ? const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : const TextStyle(
                                                      fontSize: 10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                              child: index == 0
                                                  ? const Text(
                                                      ModelFeeStructure
                                                          .paidStatusKey,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(singleCourseFeeInfo[
                                                          ModelFeeStructure
                                                              .paidStatusKey]
                                                      [index - 1])),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              index == 0
                                                  ? ModelFeeStructure
                                                      .outStandingKey
                                                  : '${singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1]}',
                                              style: index == 0
                                                  ? const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : const TextStyle(
                                                      fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Text('No data');
                }
              },
            ),
          ),
        ));
  }
}
