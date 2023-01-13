import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

import '../provider/ModelFeeStructure.dart';
import '../provider/model_add_student.dart';
import '../provider/model_fee_voucher.dart';
import '../util/firebase_db_handler.dart';
import '../util/network_authentication.dart';
import '../util/validation.dart';
import '../widget/custom_profile.dart';
import '../widget/custom_textfield.dart';
import '../widget/voucher.dart';

class AddFee extends StatefulWidget {
  final List<String>? userStatus;
  const AddFee({Key? key, required this.userStatus}) : super(key: key);
  static const pageName = '/AddFee';

  @override
  _AddFeeState createState() => _AddFeeState();
}

class _AddFeeState extends State<AddFee> {
  late TextEditingController controllerCNIC;
  late TextEditingController controllerAmount;
  final amountGlobalKey = GlobalKey<FormState>();
  final cnicGlobalKey = GlobalKey<FormFieldState>();
  DateTime? dateToday;
  bool check = false;

  @override
  void initState() {
    super.initState();
    controllerAmount = TextEditingController();
    controllerCNIC = TextEditingController();
  }

  @override
  void dispose() {
    controllerCNIC.dispose();
    controllerAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    dateToday = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Fee'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(
                            1,
                            1,
                          ),
                          spreadRadius: 1,
                          blurRadius: 15)
                    ]),
                    child: TextFormField(
                      key: cnicGlobalKey,
                      controller: controllerCNIC,
                      validator: (value) =>
                          ModelValidation.cnicValidation(value.toString()),
                      keyboardType: TextInputType.number,
                      maxLength: 15,
                      inputFormatters: [
                        MaskedInputFormatter('#####-#######-#',
                            allowedCharMatcher: RegExp(r'[0-9]'))
                      ],
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          filled: true,
                          prefixIconColor: Colors.red,
                          prefixIcon: const Icon(
                            Icons.perm_identity,
                            color: Colors.black,
                          ),
                          suffix: IconButton(
                            onPressed: () {
                              NetworkAuth.check().then((internet) async {
                                if (internet) {
                                  if (cnicGlobalKey.currentState!.validate()) {
                                    print(
                                        '.................clickno.......................');
                                    var studentCourseEnrollmentDOCS;
                                    if (widget.userStatus
                                        .toString()
                                        .contains('SuperAdmin')) {
                                      print(
                                          '///////////////////if///////////////');
                                      studentCourseEnrollmentDOCS = await DBHandler
                                              .studentCourseEnrollmentCollection(
                                                  controllerCNIC.text
                                                      .toString()
                                                      .trim())
                                          .get();
                                    } else {
                                      studentCourseEnrollmentDOCS = await DBHandler
                                              .studentCourseEnrollmentCollectionWithUserUID(
                                                  controllerCNIC.text
                                                      .toString(),
                                                  widget.userStatus![2]
                                                      .toString())
                                          .get();
                                    }

                                    for (int docsCount = 0;
                                        docsCount <
                                            studentCourseEnrollmentDOCS
                                                .docs.length;
                                        docsCount++) {
                                      var singleCourseFee =
                                          studentCourseEnrollmentDOCS
                                              .docs[docsCount];
                                      print(
                                          '................${singleCourseFee[ModelFeeStructure.payableKey]}');
                                      var outStandingList = singleCourseFee[
                                          ModelFeeStructure.outStandingKey];
                                      var paidStatusList = singleCourseFee[
                                          ModelFeeStructure.paidStatusKey];
                                      String startingDate = singleCourseFee[
                                          ModelFeeStructure.dateKey];
                                      DateTime currentDate = DateTime(
                                          dateToday!.year, dateToday!.month, 1);
                                      DateTime datePicker = DateTime(
                                          int.parse(
                                              startingDate.substring(0, 4)),
                                          int.parse(
                                              startingDate.substring(5, 7)),
                                          int.parse(
                                              startingDate.substring(8, 10)));
                                      var lastInstalmentDate = DateTime(
                                          datePicker.year,
                                          datePicker.month +
                                              int.parse((singleCourseFee[
                                                          ModelFeeStructure
                                                              .minInstallmentKey] -
                                                      1)
                                                  .toString()),
                                          1);
                                      print(
                                          '//////////////$lastInstalmentDate//r4frfrfrfrfrfr//////////');
                                      if (currentDate
                                          .isBefore(lastInstalmentDate)) {
                                        for (int installmentCount = 0;
                                            installmentCount <
                                                singleCourseFee[
                                                    ModelFeeStructure
                                                        .minInstallmentKey];
                                            installmentCount++) {
                                          var instalmentDate = DateTime(
                                              datePicker.year,
                                              datePicker.month +
                                                  (installmentCount),
                                              installmentCount == 0
                                                  ? datePicker.day
                                                  : 1);
                                          print(
                                              '.................$instalmentDate.........................');
                                          if (currentDate
                                              .isAfter(instalmentDate)) {
                                            print(
                                                '....................$currentDate,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,');
                                            outStandingList[installmentCount +
                                                1] = outStandingList[
                                                    installmentCount] +
                                                outStandingList[
                                                    installmentCount + 1];
                                            outStandingList[installmentCount] =
                                                0.0;
                                            paidStatusList[installmentCount] =
                                                'Paid';

                                            print(
                                                '/////////////////$outStandingList/hello//////////');
                                          }
                                        }
                                      } else {
                                        print(
                                            '/////////////out of bound///////');
                                      }
                                      print('////////////update/////////');
                                      print(
                                          '/////////$outStandingList///////////////');
                                      print(
                                          '/////////$paidStatusList///////////////');

                                      widget.userStatus
                                              .toString()
                                              .contains('SuperAdmin')
                                          ? DBHandler
                                                  .studentCourseEnrollmentCollection(
                                                      controllerCNIC.text
                                                          .toString())
                                              .doc(singleCourseFee[
                                                  ModelFeeStructure.titleKey])
                                              .update({
                                              ModelFeeStructure.outStandingKey:
                                                  outStandingList,
                                              ModelFeeStructure.paidStatusKey:
                                                  paidStatusList,
                                            })
                                          : DBHandler
                                                  .studentCourseEnrollmentCollectionWithUserUID(
                                                      controllerCNIC.text
                                                          .toString(),
                                                      widget.userStatus![2]
                                                          .toString())
                                              .doc(singleCourseFee[
                                                  ModelFeeStructure.titleKey])
                                              .update({
                                              ModelFeeStructure.outStandingKey:
                                                  outStandingList,
                                              ModelFeeStructure.paidStatusKey:
                                                  paidStatusList,
                                            });
                                    }
                                    setState(() {
                                      check = true;
                                    });
                                  } else {
                                    setState(() {
                                      check = false;
                                    });
                                  }
                                } else {
                                  NetworkAuth.showNow(mainContext);
                                }
                              });
                            },
                            icon: const Icon(Icons.search),
                          ),
                          label: const Text('CNIC'),
                          labelStyle: const TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 1)),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                ),
                check == true
                    ? StreamBuilder<QuerySnapshot>(
                        stream: widget.userStatus
                                .toString()
                                .contains('SuperAdmin')
                            ? DBHandler.studentCourseEnrollmentCollection(
                                    controllerCNIC.text.toString())
                                .snapshots()
                            : DBHandler
                                    .studentCourseEnrollmentCollectionWithUserUID(
                                        controllerCNIC.text.toString(),
                                        widget.userStatus![2].toString())
                                .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> snapshotData) {
                          if (snapshotData.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshotData.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshotData.hasData) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * .7,
                              child: ListView.builder(
                                itemCount: snapshotData.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var singleCourseFeeInfo =
                                      snapshotData.data!.docs[index];

                                  String currentDate = singleCourseFeeInfo[
                                      ModelFeeStructure.dateKey];

                                  var datePicker = DateTime(
                                      int.parse(currentDate.substring(0, 4)),
                                      int.parse(currentDate.substring(5, 7)),
                                      int.parse(currentDate.substring(8, 10)));
                                  print(
                                      '////////////$datePicker///////////////////');
                                  return Center(
                                    child: Padding(
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
                                              singleCourseFeeInfo[
                                                      ModelFeeStructure
                                                          .minInstallmentKey] +
                                                  1,
                                              (index) => TableRow(children: [
                                                SizedBox(
                                                  height: 50,
                                                  child: Center(
                                                    child: Text(
                                                      index == 0
                                                          ? ModelFeeStructure
                                                              .titleKey
                                                          : '${singleCourseFeeInfo[ModelFeeStructure.titleKey]}',
                                                      style: index == 0
                                                          ? const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)
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
                                                          ? ModelFeeStructure
                                                              .payableKey
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
                                                                  FontWeight
                                                                      .bold)
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
                                                          ? ModelFeeStructure
                                                              .dateKey
                                                          : DateTime(
                                                                  datePicker
                                                                      .year,
                                                                  datePicker
                                                                          .month +
                                                                      (index -
                                                                          1),
                                                                  index < 2
                                                                      ? datePicker
                                                                          .day
                                                                      : 05)
                                                              .toString()
                                                              .substring(0, 10),
                                                      style: index == 0
                                                          ? const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)
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
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        //////////////////////////////////////////////////////////
                                                        : TextButton(
                                                            onPressed:
                                                                () async {
                                                              dateToday =
                                                                  DateTime
                                                                      .now();
                                                              if (singleCourseFeeInfo[
                                                                      ModelFeeStructure
                                                                          .paidStatusKey][index -
                                                                      1] ==
                                                                  'unPaid') {
                                                                print(
                                                                    '.......................click..........................');
                                                                var singleStudent;
                                                                String name;
                                                                if (widget
                                                                    .userStatus
                                                                    .toString()
                                                                    .contains(
                                                                        'SuperAdmin')) {
                                                                  singleStudent = await DBHandler.studentCollection()
                                                                      .doc(controllerCNIC
                                                                          .text
                                                                          .toString())
                                                                      .get()
                                                                      .then((value) => value
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>);
                                                                  name = singleStudent[
                                                                      ModelAddStudent
                                                                          .nameKey];
                                                                } else {
                                                                  singleStudent = await DBHandler.studentCollectionWithUID(widget
                                                                          .userStatus![
                                                                              2]
                                                                          .toString())
                                                                      .doc(controllerCNIC
                                                                          .text
                                                                          .toString())
                                                                      .get()
                                                                      .then((value) => value
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>);

                                                                  name = singleStudent[
                                                                      ModelAddStudent
                                                                          .nameKey];
                                                                }

                                                                showGeneralDialog(
                                                                    context:
                                                                        context,
                                                                    pageBuilder: (BuildContext
                                                                            alertContext,
                                                                        animation,
                                                                        secondaryAnimation) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            const Text('Do you want to pay whole installment'),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(alertContext);
                                                                              },
                                                                              child: const Text('Cancel')),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(alertContext);
                                                                                _showModalBottomSheet(
                                                                                  paidOutstandingList: singleCourseFeeInfo[ModelFeeStructure.outStandingKey],
                                                                                  paidStatusList: singleCourseFeeInfo[ModelFeeStructure.paidStatusKey],
                                                                                  mainContext: mainContext,
                                                                                  name: name,
                                                                                  installment: index.toString(),
                                                                                  groupName: singleCourseFeeInfo[ModelFeeStructure.titleKey],
                                                                                  amount: double.parse(singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1].toString()),
                                                                                  date: dateToday.toString()
                                                                                  //.substring(0, 10)
                                                                                  ,
                                                                                  time: dateToday.toString().substring(11, 19),
                                                                                );
                                                                              },
                                                                              child: const Text('NO')),
                                                                          TextButton(
                                                                              onPressed: () async {
                                                                                showGeneralDialog(
                                                                                  context: alertContext,
                                                                                  pageBuilder: (BuildContext context, animation, secondaryAnimation) {
                                                                                    return ScaleTransition(
                                                                                      scale: animation,
                                                                                      child: Container(
                                                                                        color: Colors.transparent,
                                                                                        alignment: Alignment.center,
                                                                                        child: CustomVoucher.customVoucher(
                                                                                          date: dateToday.toString().substring(0, 10),
                                                                                          installment: '$index',
                                                                                          time: dateToday.toString().substring(11, 19),
                                                                                          context: context,
                                                                                          cnic: controllerCNIC.text.toString(),
                                                                                          amount: singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1].toString(),
                                                                                          courseName: singleCourseFeeInfo[ModelFeeStructure.titleKey].toString(),
                                                                                          studentName: name,
                                                                                          onPressed: () async {
                                                                                            var installmentPaidList = singleCourseFeeInfo[ModelFeeStructure.outStandingKey];
                                                                                            var paidStatusList = singleCourseFeeInfo[ModelFeeStructure.paidStatusKey];
                                                                                            installmentPaidList[index - 1] = 0.0;
                                                                                            paidStatusList[index - 1] = 'paid';

                                                                                            if (widget.userStatus.toString().contains('SuperAdmin')) {
                                                                                              DBHandler.studentCourseEnrollmentCollection(controllerCNIC.text.toString()).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                                ModelFeeStructure.outStandingKey: installmentPaidList,
                                                                                                ModelFeeStructure.paidStatusKey: paidStatusList
                                                                                              });

                                                                                              var paidFeeHistory = ModelFeeVoucher(
                                                                                                studentName: name,
                                                                                                installment: index.toString(),
                                                                                                courseName: singleCourseFeeInfo[ModelFeeStructure.titleKey],
                                                                                                cnic: controllerCNIC.text.toString(),
                                                                                                amount: double.parse(singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1].toString()),
                                                                                                date: dateToday.toString(),
                                                                                                time: dateToday.toString().substring(11, 19),
                                                                                              );

                                                                                              // var snap = await DBHandler
                                                                                              //     .feeHistoryCollection()
                                                                                              //     .get()
                                                                                              //     .then((
                                                                                              //     document) {
                                                                                              //   return document
                                                                                              //       .docs
                                                                                              //       .length;
                                                                                              // });

                                                                                              DBHandler.feeHistoryCollection().doc('$dateToday').set(paidFeeHistory.toMap());
                                                                                            } else {
                                                                                              DBHandler.studentCourseEnrollmentCollectionWithUserUID(controllerCNIC.text.toString(), widget.userStatus![2].toString()).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                                ModelFeeStructure.outStandingKey: installmentPaidList,
                                                                                                ModelFeeStructure.paidStatusKey: paidStatusList
                                                                                              });

                                                                                              var paidFeeHistory = ModelFeeVoucher(
                                                                                                studentName: name,
                                                                                                installment: index.toString(),
                                                                                                courseName: singleCourseFeeInfo[ModelFeeStructure.titleKey],
                                                                                                cnic: controllerCNIC.text.toString(),
                                                                                                amount: double.parse(singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1].toString()),
                                                                                                date: dateToday.toString(),
                                                                                                time: dateToday.toString().substring(11, 19),
                                                                                              );

                                                                                              // var snap = await DBHandler
                                                                                              //     .feeHistoryCollectionWithUserUID(widget.userStatus![2].toString())
                                                                                              //     .get()
                                                                                              //     .then((
                                                                                              //     document) {
                                                                                              //   return document
                                                                                              //       .docs
                                                                                              //       .length;
                                                                                              // });

                                                                                              DBHandler.feeHistoryCollectionWithUserUID(widget.userStatus![2].toString()).doc('$dateToday').set(paidFeeHistory.toMap());
                                                                                            }

                                                                                            Navigator.pop(context);
                                                                                            Navigator.pop(alertContext);
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: const Text('Yes')),
                                                                        ],
                                                                      );
                                                                    });
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        content:
                                                                            Text('Fee is Paid')));
                                                              }
                                                            },
                                                            child: Text(
                                                              '${singleCourseFeeInfo[ModelFeeStructure.paidStatusKey][index - 1]}',
                                                            ),
                                                          ),
                                                  ),
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
                                                                  FontWeight
                                                                      .bold)
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
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Text('Cnic not found');
                          }
                        },
                      )
                    : const Text('no data')
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showModalBottomSheet(
      {required String name,
      required String groupName,
      required String installment,
      required double amount,
      required String date,
      required List paidStatusList,
      required List paidOutstandingList,
      required String time,
      required BuildContext mainContext}) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (bottomSheetContext) {
        return Padding(
          padding: MediaQuery.of(bottomSheetContext).viewInsets,
          child: Container(
            height: MediaQuery.of(bottomSheetContext).size.height * .4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: amountGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomProfileWidget.customProfileText(
                        text: amount.toString(),
                        title: 'Total Installment',
                        context: bottomSheetContext),
                    CustomWidget.customTextField(
                        controller: controllerAmount,
                        textInputType: TextInputType.number,
                        icon: Icons.discount,
                        titleName: 'Enter Amount',
                        validate: (String? value) {
                          if (value!.isNotEmpty) {
                            if (amount >
                                double.parse(
                                    controllerAmount.text.toString())) {
                              return null;
                            } else {
                              return 'Amount must less than installment amount';
                            }
                          } else {
                            return 'required';
                          }
                        }),
                    ElevatedButton(
                        onPressed: () {
                          if (amountGlobalKey.currentState!.validate()) {
                            print('hello//////////////////////////////');
                            showGeneralDialog(
                              context: mainContext,
                              pageBuilder: (BuildContext voucherContext,
                                  animation, secondaryAnimation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: Container(
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: CustomVoucher.customVoucher(
                                      date:
                                          dateToday.toString().substring(0, 10),
                                      installment: installment,
                                      time: time,
                                      context: voucherContext,
                                      cnic: controllerCNIC.text.toString(),
                                      amount: controllerAmount.text.toString(),
                                      courseName: groupName,
                                      studentName: name,
                                      onPressed: () async {
                                        paidOutstandingList[
                                                int.parse(installment) - 1] =
                                            amount -
                                                double.parse(controllerAmount
                                                    .text
                                                    .toString());
                                        //paidStatusList[index - 1] = 'paid';
                                        if (widget.userStatus
                                            .toString()
                                            .contains('SuperAdmin')) {
                                          DBHandler
                                                  .studentCourseEnrollmentCollection(
                                                      controllerCNIC.text
                                                          .toString())
                                              .doc(groupName)
                                              .update({
                                            ModelFeeStructure.outStandingKey:
                                                paidOutstandingList,
                                          });

                                          var paidFeeHistory = ModelFeeVoucher(
                                            studentName: name,
                                            installment: installment,
                                            courseName: groupName,
                                            cnic:
                                                controllerCNIC.text.toString(),
                                            amount: double.parse(
                                                controllerAmount.text
                                                    .toString()),
                                            date: date,
                                            time: time,
                                          );

                                          // var snap = await DBHandler
                                          //     .feeHistoryCollection()
                                          //     .get()
                                          //     .then((document) {
                                          //   return document.docs.length;
                                          // });

                                          DBHandler.feeHistoryCollection()
                                              .doc('$dateToday')
                                              .set(paidFeeHistory.toMap());
                                        } else {
                                          DBHandler
                                                  .studentCourseEnrollmentCollectionWithUserUID(
                                                      controllerCNIC.text
                                                          .toString(),
                                                      widget.userStatus![2]
                                                          .toString())
                                              .doc(groupName)
                                              .update({
                                            ModelFeeStructure.outStandingKey:
                                                paidOutstandingList,
                                          });

                                          var paidFeeHistory = ModelFeeVoucher(
                                            studentName: name,
                                            installment: installment,
                                            courseName: groupName,
                                            cnic:
                                                controllerCNIC.text.toString(),
                                            amount: double.parse(
                                                controllerAmount.text
                                                    .toString()),
                                            date: date,
                                            time: time,
                                          );

                                          // var snap = await DBHandler
                                          //     .feeHistoryCollectionWithUserUID(widget.userStatus![2].toString())
                                          //     .get()
                                          //     .then((document) {
                                          //   return document.docs.length;
                                          // });

                                          DBHandler
                                                  .feeHistoryCollectionWithUserUID(
                                                      widget.userStatus![2]
                                                          .toString())
                                              .doc('$dateToday')
                                              .set(paidFeeHistory.toMap());
                                        }
                                        Navigator.pop(bottomSheetContext);
                                        Navigator.pop(voucherContext);
                                        controllerAmount.clear();
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: const Text('Submit'))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
