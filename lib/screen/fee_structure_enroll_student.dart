import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/ModelFeeStructure.dart';
import '../provider/model_add_student.dart';
import '../provider/model_fee_voucher.dart';
import '../util/firebase_db_handler.dart';
import '../widget/custom_profile.dart';
import '../widget/custom_textfield.dart';
import '../widget/voucher.dart';

class FeeStructure extends StatefulWidget {
  final List<String>? userStatus;

  const FeeStructure({Key? key, required this.userStatus}) : super(key: key);
  static const pageName = '/FeeStructureEnrollment';

  @override
  _FeeStructureState createState() => _FeeStructureState();
}

class _FeeStructureState extends State<FeeStructure> {
  String whole = 'whole';
  String installments = 'installments';
  List<double> controller = <double>[];
  List<String> paidStatusList = [];
  List<double> installmentPaidList = [];
  late TextEditingController concessionController;
  late TextEditingController controllerAmount;
  final amountGlobalKey = GlobalKey<FormState>();
  final concessionGlobalKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool check = false;
  bool checkController = true;
  var singleStudent;
  String paymentMethod = '';
  DateTime? dateToday;

  @override
  void initState() {
    super.initState();
    controllerAmount = TextEditingController();
    concessionController = TextEditingController();
  }

  @override
  void dispose() {
    concessionController.dispose();
    controllerAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    dateToday = DateTime.now();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Fee Structure'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.6
                : MediaQuery.of(context).size.width,
            child: FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder:
                  (context, AsyncSnapshot<SharedPreferences> snapshotPref) {
                if (snapshotPref.hasData &&
                    snapshotPref.data!.containsKey('cnic')) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: widget.userStatus
                              .toString()
                              .contains('SuperAdmin')
                          ? DBHandler.studentCourseEnrollmentCollection(
                                  snapshotPref.data!.getString('cnic')!)
                              .snapshots()
                          : DBHandler
                                  .studentCourseEnrollmentCollectionWithUserUID(
                                      snapshotPref.data!.getString('cnic')!,
                                      widget.userStatus![2].toString())
                              .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshotData) {
                        if (snapshotData.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshotData.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshotData.data!.docs.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshotData.data!.docs.length,
                            itemBuilder: (context, indexPerCourse) {
                              Map<String, dynamic> singleCourseFeeInfo =
                                  snapshotData.data!.docs[indexPerCourse].data()
                                      as Map<String, dynamic>;
                              if (checkController) {
                                for (int i = 0;
                                    i < snapshotData.data!.docs.length;
                                    i++) {
                                  controller.add(0.0);
                                }
                                checkController = false;
                              }

                              String currentDate = singleCourseFeeInfo[
                                  ModelFeeStructure.dateKey];
                              var datePicker = DateTime(
                                  int.parse(currentDate.substring(0, 4)),
                                  int.parse(currentDate.substring(5, 7)),
                                  int.parse(currentDate.substring(8, 10)));
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          child: CustomProfileWidget.customProfileText(
                                              text:
                                                  '${singleCourseFeeInfo[ModelFeeStructure.payableKey]}',
                                              title:
                                                  '${singleCourseFeeInfo[ModelFeeStructure.titleKey]}',
                                              context: context),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black12
                                                            .withOpacity(0.05),
                                                        offset: const Offset(
                                                          0.5,
                                                          0.5,
                                                        ),
                                                        spreadRadius: 1,
                                                        blurRadius: 3)
                                                  ]),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: TextButton(
                                                    onPressed: () {
                                                      concessionController
                                                          .clear();
                                                      showGeneralDialog(
                                                          context: _scaffoldKey
                                                              .currentContext!,
                                                          pageBuilder: (BuildContext
                                                                  context,
                                                              animation,
                                                              secondaryAnimation) {
                                                            return Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    .3,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .7,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            2)),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            Form(
                                                                          key:
                                                                              concessionGlobalKey,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(12.0),
                                                                            child: CustomWidget.customTextField(
                                                                                textInputType: TextInputType.number,
                                                                                controller: concessionController,
                                                                                icon: Icons.discount,
                                                                                titleName: 'Concession',
                                                                                validate: (String? value) {
                                                                                  if (value!.isNotEmpty) {
                                                                                    if (singleCourseFeeInfo[ModelFeeStructure.payableKey] > double.parse(concessionController.text.toString())) {
                                                                                      return null;
                                                                                    } else {
                                                                                      return 'Amount must less than course fee';
                                                                                    }
                                                                                  } else {
                                                                                    return 'required';
                                                                                  }
                                                                                }),
                                                                          ),
                                                                        )),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                const Text('Cancel')),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 16.0),
                                                                          child: TextButton(
                                                                              onPressed: () {
                                                                                if (concessionGlobalKey.currentState!.validate()) {
                                                                                  double concession = singleCourseFeeInfo[ModelFeeStructure.payableKey] - double.parse(concessionController.text.toString());
                                                                                  widget.userStatus.toString().contains('SuperAdmin')
                                                                                      ? DBHandler.studentCourseEnrollmentCollection(snapshotPref.data!.getString('cnic')!).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                          ModelFeeStructure.payableKey: concession,
                                                                                        })
                                                                                      : DBHandler.studentCourseEnrollmentCollectionWithUserUID(snapshotPref.data!.getString('cnic')!, widget.userStatus![2].toString()).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                          ModelFeeStructure.payableKey: concession,
                                                                                        });
                                                                                  Navigator.pop(context);
                                                                                } else {
                                                                                  concessionController.clear();
                                                                                }
                                                                              },
                                                                              child: const Text('Done')),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: const Text(
                                                        'Concession')),
                                              )),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        height: 50,
                                        // width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(
                                                    3,
                                                    3,
                                                  ),
                                                  spreadRadius: 5,
                                                  blurRadius: 5)
                                            ]),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text(
                                              'Payment Method :',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Radio<String>(
                                                    value:
                                                        '$whole$indexPerCourse',
                                                    groupValue: paymentMethod,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        paymentMethod = value!;
                                                      });
                                                      widget.userStatus
                                                              .toString()
                                                              .contains(
                                                                  'SuperAdmin')
                                                          ? DBHandler.studentCourseEnrollmentCollection(
                                                                  snapshotPref
                                                                      .data!
                                                                      .getString(
                                                                          'cnic')!)
                                                              .doc(singleCourseFeeInfo[
                                                                  ModelFeeStructure
                                                                      .titleKey])
                                                              .update({
                                                              ModelFeeStructure
                                                                  .minInstallmentKey: 1,
                                                              ModelFeeStructure
                                                                  .outStandingKey: [
                                                                singleCourseFeeInfo[
                                                                    ModelFeeStructure
                                                                        .payableKey]
                                                              ],
                                                              ModelFeeStructure
                                                                  .paidStatusKey: [
                                                                'unPaid'
                                                              ],
                                                              ModelFeeStructure
                                                                  .payableInstallmentKey: [
                                                                singleCourseFeeInfo[
                                                                    ModelFeeStructure
                                                                        .payableKey]
                                                              ]
                                                            })
                                                          : DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                                                                  snapshotPref
                                                                      .data!
                                                                      .getString(
                                                                          'cnic')!,
                                                                  widget.userStatus![2]
                                                                      .toString())
                                                              .doc(singleCourseFeeInfo[
                                                                  ModelFeeStructure
                                                                      .titleKey])
                                                              .update({
                                                              ModelFeeStructure
                                                                  .minInstallmentKey: 1,
                                                              ModelFeeStructure
                                                                  .outStandingKey: [
                                                                singleCourseFeeInfo[
                                                                    ModelFeeStructure
                                                                        .payableKey]
                                                              ],
                                                              ModelFeeStructure
                                                                  .paidStatusKey: [
                                                                'unPaid'
                                                              ],
                                                              ModelFeeStructure
                                                                  .payableInstallmentKey: [
                                                                singleCourseFeeInfo[
                                                                    ModelFeeStructure
                                                                        .payableKey]
                                                              ]
                                                            });
                                                    }),
                                                const Text(
                                                  'Whole',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio<String>(
                                                    value:
                                                        '$installments$indexPerCourse',
                                                    groupValue: paymentMethod,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        paymentMethod = value!;
                                                      });
                                                    }),
                                                const Text(
                                                  'Installments',
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    paymentMethod == '$whole$indexPerCourse'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 24.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Table(
                                                defaultColumnWidth:
                                                    const FixedColumnWidth(100),
                                                border: TableBorder.all(
                                                    color:
                                                        Colors.blue.shade600),
                                                children: List.generate(
                                                  2,
                                                  (index) => TableRow(
                                                      children: [
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
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)
                                                                  : const TextStyle(
                                                                      fontSize:
                                                                          10),
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
                                                                  : '${singleCourseFeeInfo[ModelFeeStructure.payableKey]}',
                                                              style: index == 0
                                                                  ? const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)
                                                                  : const TextStyle(
                                                                      fontSize:
                                                                          10),
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
                                                                  : '${singleCourseFeeInfo[ModelFeeStructure.dateKey]}',
                                                              style: index == 0
                                                                  ? const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)
                                                                  : const TextStyle(
                                                                      fontSize:
                                                                          10),
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
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      dateToday =
                                                                          DateTime
                                                                              .now();
                                                                      if (singleCourseFeeInfo[ModelFeeStructure.paidStatusKey]
                                                                              [
                                                                              0] ==
                                                                          'unPaid') {
                                                                        if (widget
                                                                            .userStatus
                                                                            .toString()
                                                                            .contains('SuperAdmin')) {
                                                                          singleStudent = await DBHandler.studentCollection()
                                                                              .doc(snapshotPref.data!.getString('cnic'))
                                                                              .get()
                                                                              .then((value) => value.data() as Map<String, dynamic>);
                                                                        } else {
                                                                          singleStudent = await DBHandler.studentCollectionWithUID(widget.userStatus![2].toString())
                                                                              .doc(snapshotPref.data!.getString('cnic'))
                                                                              .get()
                                                                              .then((value) => value.data() as Map<String, dynamic>);
                                                                        }

                                                                        var name =
                                                                            singleStudent[ModelAddStudent.nameKey];

                                                                        showGeneralDialog(
                                                                          context:
                                                                              _scaffoldKey.currentContext!,
                                                                          pageBuilder: (BuildContext context,
                                                                              animation,
                                                                              secondaryAnimation) {
                                                                            return ScaleTransition(
                                                                              scale: animation,
                                                                              child: Container(
                                                                                color: Colors.transparent,
                                                                                alignment: Alignment.center,
                                                                                child: CustomVoucher.customVoucher(
                                                                                  date: dateToday.toString().substring(0, 10),
                                                                                  time: dateToday.toString().substring(11, 19),
                                                                                  installment: index.toString(),
                                                                                  context: _scaffoldKey.currentContext!,
                                                                                  cnic: snapshotPref.data!.getString('cnic').toString(),
                                                                                  amount: singleCourseFeeInfo[ModelFeeStructure.payableKey].toString(),
                                                                                  courseName: singleCourseFeeInfo[ModelFeeStructure.titleKey].toString(),
                                                                                  studentName: name,
                                                                                  onPressed: () async {
                                                                                    ///////////////////////////////////////////////////////////
                                                                                    widget.userStatus.toString().contains('SuperAdmin')
                                                                                        ? DBHandler.studentCourseEnrollmentCollection(snapshotPref.data!.getString('cnic')!).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                            ModelFeeStructure.outStandingKey: [0.0],
                                                                                            ModelFeeStructure.paidStatusKey: ['Paid']
                                                                                          })
                                                                                        : DBHandler.studentCourseEnrollmentCollectionWithUserUID(snapshotPref.data!.getString('cnic')!, widget.userStatus![2].toString()).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                            ModelFeeStructure.outStandingKey: [0.0],
                                                                                            ModelFeeStructure.paidStatusKey: ['Paid']
                                                                                          });
                                                                                    var paidFeeHistory = ModelFeeVoucher(
                                                                                      studentName: name,
                                                                                      installment: index.toString(),
                                                                                      courseName: singleCourseFeeInfo[ModelFeeStructure.titleKey],
                                                                                      cnic: snapshotPref.data!.getString('cnic')!,
                                                                                      amount: singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1],
                                                                                      date: dateToday.toString(),
                                                                                      time: dateToday.toString().substring(11, 19),
                                                                                    );

                                                                                    if (widget.userStatus.toString().contains('SuperAdmin')) {
                                                                                      // var snap = await DBHandler.feeHistoryCollection().get().then((document) {
                                                                                      //   return document.docs.length;
                                                                                      // });

                                                                                      DBHandler.feeHistoryCollection().doc('$dateToday').set(paidFeeHistory.toMap());
                                                                                    } else {
                                                                                      // var snap = await DBHandler.feeHistoryCollectionWithUserUID(widget.userStatus![2].toString()).get().then((document) {
                                                                                      //   return document.docs.length;
                                                                                      // });

                                                                                      DBHandler.feeHistoryCollectionWithUserUID(widget.userStatus![2].toString()).doc('$dateToday').set(paidFeeHistory.toMap());
                                                                                    }

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      } else {
                                                                        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(const SnackBar(
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            content: Text('Fee is Paid')));
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        '${singleCourseFeeInfo[ModelFeeStructure.paidStatusKey][0]}')),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                          child: Center(
                                                            child: Text(
                                                              index == 0
                                                                  ? ModelFeeStructure
                                                                      .outStandingKey
                                                                  : '${singleCourseFeeInfo[ModelFeeStructure.outStandingKey][0]}',
                                                              style: index == 0
                                                                  ? const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)
                                                                  : const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          )
                                        ///////////////////////////////////////////////////////installments////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        : paymentMethod ==
                                                '$installments$indexPerCourse'
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 8,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .black12
                                                                          .withOpacity(
                                                                              0.05),
                                                                      offset:
                                                                          const Offset(
                                                                        0.5,
                                                                        0.5,
                                                                      ),
                                                                      spreadRadius:
                                                                          1,
                                                                      blurRadius:
                                                                          3)
                                                                ]),
                                                            child: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                controller[
                                                                        indexPerCourse] =
                                                                    double.parse(
                                                                        value
                                                                            .toString());
                                                              },
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                      label:
                                                                          const FittedBox(
                                                                        child: Text(
                                                                            'Per Month Installment'),
                                                                      ),
                                                                      labelStyle: const TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                      // suffix: const Text('Generate'),

                                                                      prefixIcon:
                                                                          const Icon(
                                                                        Icons
                                                                            .payments,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      focusedBorder:
                                                                          const OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.blueGrey, width: 1)),
                                                                      border: UnderlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      )),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                            flex: 2,
                                                            child: Container(
                                                                height: 40,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors.black12.withOpacity(
                                                                              0.05),
                                                                          offset:
                                                                              const Offset(
                                                                            0.5,
                                                                            0.5,
                                                                          ),
                                                                          spreadRadius:
                                                                              1,
                                                                          blurRadius:
                                                                              3)
                                                                    ]),
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          paidStatusList
                                                                              .clear();
                                                                          installmentPaidList
                                                                              .clear();

                                                                          widget.userStatus.toString().contains('SuperAdmin')
                                                                              ? DBHandler.studentCourseEnrollmentCollection(snapshotPref.data!.getString('cnic')!).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                  ModelFeeStructure.paidStatusKey: paidStatusList,
                                                                                  ModelFeeStructure.outStandingKey: [
                                                                                    singleCourseFeeInfo[ModelFeeStructure.payableKey]
                                                                                  ]
                                                                                })
                                                                              : DBHandler.studentCourseEnrollmentCollectionWithUserUID(snapshotPref.data!.getString('cnic')!, widget.userStatus![2].toString()).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                  ModelFeeStructure.paidStatusKey: paidStatusList,
                                                                                  ModelFeeStructure.outStandingKey: [
                                                                                    singleCourseFeeInfo[ModelFeeStructure.payableKey]
                                                                                  ]
                                                                                });
                                                                          if (controller[indexPerCourse] !=
                                                                              0) {
                                                                            setState(() {
                                                                              check = true;
                                                                            });
                                                                            double
                                                                                value =
                                                                                singleCourseFeeInfo[ModelFeeStructure.payableKey] / controller[indexPerCourse];

                                                                            for (int i = 0;
                                                                                i < value.round();
                                                                                i++) {
                                                                              paidStatusList.add('unPaid');
                                                                              double installmentPaid = i < value.round() - 1 ? (controller[indexPerCourse]) : ((singleCourseFeeInfo[ModelFeeStructure.payableKey]) - (double.parse(controller[indexPerCourse].toString()) * (value.round() - 1)));
                                                                              installmentPaidList.add(double.parse(installmentPaid.toString()));
                                                                            }

                                                                            widget.userStatus.toString().contains('SuperAdmin')
                                                                                ? DBHandler.studentCourseEnrollmentCollection(snapshotPref.data!.getString('cnic')!).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                    ModelFeeStructure.minInstallmentKey: value.round(),
                                                                                    ModelFeeStructure.paidStatusKey: paidStatusList,
                                                                                    ModelFeeStructure.outStandingKey: installmentPaidList,
                                                                                    ModelFeeStructure.payableInstallmentKey: installmentPaidList
                                                                                  })
                                                                                : DBHandler.studentCourseEnrollmentCollectionWithUserUID(snapshotPref.data!.getString('cnic')!, widget.userStatus![2].toString()).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                    ModelFeeStructure.minInstallmentKey: value.round(),
                                                                                    ModelFeeStructure.paidStatusKey: paidStatusList,
                                                                                    ModelFeeStructure.outStandingKey: installmentPaidList,
                                                                                    ModelFeeStructure.payableInstallmentKey: installmentPaidList
                                                                                  });
                                                                          } else {
                                                                            setState(() {
                                                                              check = false;
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            const FittedBox(
                                                                          fit: BoxFit
                                                                              .scaleDown,
                                                                          child:
                                                                              Text('Generate'),
                                                                        ))))
                                                      ],
                                                    ),
                                                    check
                                                        ? singleCourseFeeInfo[
                                                                        ModelFeeStructure
                                                                            .minInstallmentKey] <=
                                                                    singleCourseFeeInfo[
                                                                        ModelFeeStructure
                                                                            .maxInstallmentKey] &&
                                                                controller[
                                                                        indexPerCourse] <
                                                                    singleCourseFeeInfo[
                                                                        ModelFeeStructure
                                                                            .payableKey]
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            24.0),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child: Table(
                                                                    defaultColumnWidth:
                                                                        const FixedColumnWidth(
                                                                            100),
                                                                    border: TableBorder.all(
                                                                        color: Colors
                                                                            .blue
                                                                            .shade600),
                                                                    children: List
                                                                        .generate(
                                                                      singleCourseFeeInfo[
                                                                              ModelFeeStructure.minInstallmentKey] +
                                                                          1,
                                                                      (index) =>
                                                                          TableRow(
                                                                              children: [
                                                                            SizedBox(
                                                                              height: 50,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  index == 0 ? ModelFeeStructure.titleKey : '${singleCourseFeeInfo[ModelFeeStructure.titleKey]}',
                                                                                  style: index == 0 ? const TextStyle(fontSize: 12, fontWeight: FontWeight.bold) : const TextStyle(fontSize: 10),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 50,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  index == 0
                                                                                      ? ModelFeeStructure.payableKey
                                                                                      : index < singleCourseFeeInfo[ModelFeeStructure.minInstallmentKey]
                                                                                          ? '${controller[indexPerCourse]}'
                                                                                          : '${((singleCourseFeeInfo[ModelFeeStructure.payableKey]) - (controller[indexPerCourse] * (singleCourseFeeInfo[ModelFeeStructure.minInstallmentKey] - 1)))}',
                                                                                  style: index == 0 ? const TextStyle(fontSize: 12, fontWeight: FontWeight.bold) : const TextStyle(fontSize: 10),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 50,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  index == 0 ? ModelFeeStructure.dateKey : DateTime(datePicker.year, datePicker.month + (index - 1), index < 2 ? datePicker.day : 05).toString().substring(0, 10),
                                                                                  style: index == 0 ? const TextStyle(fontSize: 12, fontWeight: FontWeight.bold) : const TextStyle(fontSize: 10),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 50,
                                                                              child: Center(
                                                                                child: index == 0
                                                                                    ? const Text(
                                                                                        ModelFeeStructure.paidStatusKey,
                                                                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                                      )
                                                                                    : TextButton(
                                                                                        onPressed: () async {
                                                                                          dateToday = DateTime.now();
                                                                                          ////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                          if (singleCourseFeeInfo[ModelFeeStructure.paidStatusKey][index - 1] == 'unPaid') {
                                                                                            print('.......................click..........................');
                                                                                            var singleStudent;
                                                                                            var name;
                                                                                            if (widget.userStatus.toString().contains('SuperAdmin')) {
                                                                                              singleStudent = await DBHandler.studentCollection().doc(snapshotPref.data!.getString('cnic')!).get().then((value) => value.data() as Map<String, dynamic>);
                                                                                              name = singleStudent[ModelAddStudent.nameKey];
                                                                                            } else {
                                                                                              singleStudent = await DBHandler.studentCollectionWithUID(widget.userStatus![2].toString()).doc(snapshotPref.data!.getString('cnic')!).get().then((value) => value.data() as Map<String, dynamic>);
                                                                                              name = singleStudent[ModelAddStudent.nameKey];
                                                                                            }
                                                                                            showGeneralDialog(
                                                                                                context: _scaffoldKey.currentContext!,
                                                                                                pageBuilder: (BuildContext alertContext, animation, secondaryAnimation) {
                                                                                                  return AlertDialog(
                                                                                                    content: const Text('Do you want to pay whole installment'),
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
                                                                                                              cnic: snapshotPref.data!.getString('cnic')!,
                                                                                                              installment: index.toString(),
                                                                                                              groupName: singleCourseFeeInfo[ModelFeeStructure.titleKey],
                                                                                                              amount: singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1],
                                                                                                              date: dateToday.toString(),
                                                                                                              time: dateToday.toString().substring(11, 19),
                                                                                                            );
                                                                                                          },
                                                                                                          child: const Text('NO')),
                                                                                                      TextButton(
                                                                                                          onPressed: () async {
                                                                                                            dateToday = DateTime.now();
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
                                                                                                                      context: _scaffoldKey.currentContext!,
                                                                                                                      cnic: snapshotPref.data!.getString('cnic')!,
                                                                                                                      amount: singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1].toString(),
                                                                                                                      courseName: singleCourseFeeInfo[ModelFeeStructure.titleKey].toString(),
                                                                                                                      studentName: name,
                                                                                                                      onPressed: () async {
                                                                                                                        var paidFeeHistory = ModelFeeVoucher(
                                                                                                                          studentName: name,
                                                                                                                          installment: index.toString(),
                                                                                                                          courseName: singleCourseFeeInfo[ModelFeeStructure.titleKey],
                                                                                                                          cnic: snapshotPref.data!.getString('cnic')!,
                                                                                                                          amount: singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1],
                                                                                                                          date: dateToday.toString(),
                                                                                                                          time: dateToday.toString().substring(11, 19),
                                                                                                                        );

                                                                                                                        var installmentPaidList = singleCourseFeeInfo[ModelFeeStructure.outStandingKey];
                                                                                                                        var paidStatusList = singleCourseFeeInfo[ModelFeeStructure.paidStatusKey];
                                                                                                                        installmentPaidList[index - 1] = 0.0;
                                                                                                                        paidStatusList[index - 1] = 'paid';

                                                                                                                        if (widget.userStatus.toString().contains('SuperAdmin')) {
                                                                                                                          DBHandler.studentCourseEnrollmentCollection(snapshotPref.data!.getString('cnic')!).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                                                            ModelFeeStructure.outStandingKey: installmentPaidList,
                                                                                                                            ModelFeeStructure.paidStatusKey: paidStatusList
                                                                                                                          });

                                                                                                                          // var snap = await DBHandler.feeHistoryCollection().get().then((document) {
                                                                                                                          //   return document.docs.length;
                                                                                                                          // });

                                                                                                                          DBHandler.feeHistoryCollection().doc('$dateToday').set(paidFeeHistory.toMap());

                                                                                                                          ///////////////////////////////////////editing position ...................... start herre////////////////////////////////////////
                                                                                                                        } else {
                                                                                                                          DBHandler.studentCourseEnrollmentCollectionWithUserUID(snapshotPref.data!.getString('cnic')!, widget.userStatus![2].toString()).doc(singleCourseFeeInfo[ModelFeeStructure.titleKey]).update({
                                                                                                                            ModelFeeStructure.outStandingKey: installmentPaidList,
                                                                                                                            ModelFeeStructure.paidStatusKey: paidStatusList
                                                                                                                          });

                                                                                                                          // var snap = await DBHandler.feeHistoryCollectionWithUserUID(widget.userStatus![2].toString()).get().then((document) {
                                                                                                                          //   return document.docs.length;
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
                                                                                            ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Fee is Paid')));
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
                                                                                  index == 0 ? ModelFeeStructure.outStandingKey : '${singleCourseFeeInfo[ModelFeeStructure.outStandingKey][index - 1]}',
                                                                                  style: index == 0 ? const TextStyle(fontSize: 12, fontWeight: FontWeight.bold) : const TextStyle(fontSize: 10),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const Text(
                                                                'Installments are exceeded from your course duration or course fee')
                                                        : const Text('data'),
                                                  ],
                                                ),
                                              )
                                            : const Text('no Data'),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('No Group Selected'));
                        }
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Please add Student First'));
                }
              },
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
      required String cnic,
      required List paidStatusList,
      required List paidOutstandingList,
      required String time,
      required BuildContext mainContext}) {
    showModalBottomSheet(
      enableDrag: true,
      context: mainContext,
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
                                        date: dateToday
                                            .toString()
                                            .substring(0, 10),
                                        installment: installment,
                                        time: time,
                                        context: voucherContext,
                                        cnic: cnic,
                                        amount:
                                            controllerAmount.text.toString(),
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
                                                        cnic)
                                                .doc(groupName)
                                                .update({
                                              ModelFeeStructure.outStandingKey:
                                                  paidOutstandingList,
                                            });

                                            var paidFeeHistory =
                                                ModelFeeVoucher(
                                              studentName: name,
                                              installment: installment,
                                              courseName: groupName,
                                              cnic: cnic,
                                              amount: double.parse(
                                                  controllerAmount.text
                                                      .toString()),
                                              date: date,
                                              time: time,
                                            );

                                            // var snap = await DBHandler
                                            //         .feeHistoryCollection()
                                            //     .get()
                                            //     .then((document) {
                                            //   return document.docs.length;
                                            // });

                                            DBHandler.feeHistoryCollection()
                                                .doc('$dateToday')
                                                .set(paidFeeHistory.toMap());
                                            Navigator.pop(bottomSheetContext);
                                            Navigator.pop(voucherContext);
                                            controllerAmount.clear();
                                          } else {
                                            DBHandler
                                                    .studentCourseEnrollmentCollectionWithUserUID(
                                                        cnic,
                                                        widget.userStatus![2]
                                                            .toString())
                                                .doc(groupName)
                                                .update({
                                              ModelFeeStructure.outStandingKey:
                                                  paidOutstandingList,
                                            });

                                            var paidFeeHistory =
                                                ModelFeeVoucher(
                                              studentName: name,
                                              installment: installment,
                                              courseName: groupName,
                                              cnic: cnic,
                                              amount: double.parse(
                                                  controllerAmount.text
                                                      .toString()),
                                              date: date,
                                              time: time,
                                            );

                                            // var snap = await DBHandler
                                            //         .feeHistoryCollectionWithUserUID(
                                            //             widget.userStatus![2]
                                            //                 .toString())
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
                                            Navigator.pop(bottomSheetContext);
                                            Navigator.pop(voucherContext);
                                            controllerAmount.clear();
                                          }
                                        }),
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
