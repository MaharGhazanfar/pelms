import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/model_fee_voucher.dart';
import '../util/firebase_db_handler.dart';

class CarouselPages {
  static DateTime dateToday = DateTime.now();
  static Widget getCarouselSinglePage(
      {required Widget child, required Color color}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400, width: 3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                offset: Offset(1, 1),
                color: Colors.black12,
                blurRadius: 3,
                spreadRadius: 2),
            BoxShadow(
                offset: Offset(-1, -1),
                color: Colors.white10,
                blurRadius: 3,
                spreadRadius: 2)
          ]),
      child: FittedBox(fit: BoxFit.fitWidth, child: child),
    );
  }

  static Widget groupDetails({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .75,
        child: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData) {
              List<String>? userStatus =
                  snapshot.data!.getStringList('getUserInfo');
              return Column(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Groups',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width <= 400
                                ? 15
                                : 20,
                            //color: Colors.blueGrey,
                            fontStyle: FontStyle.italic),
                      ),
                      StreamBuilder(
                        stream: userStatus.toString().contains('SuperAdmin')
                            ? DBHandler.groupCollection().snapshots()
                            : DBHandler.groupCollectionWithUID(
                                    userStatus![2].toString())
                                .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.docs.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width <= 400
                                            ? 15
                                            : 20,
                                    //color: Colors.white,
                                    fontStyle: FontStyle.italic));
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Students',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width <= 400
                                        ? 15
                                        : 20,
                                //color: Colors.white,
                                fontStyle: FontStyle.italic)),
                        StreamBuilder(
                          stream: userStatus.toString().contains('SuperAdmin')
                              ? DBHandler.studentCollection().snapshots()
                              : DBHandler.studentCollectionWithUID(
                                      userStatus![2].toString())
                                  .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width <=
                                                  400
                                              ? 15
                                              : 20,
                                      // color: Colors.white,
                                      fontStyle: FontStyle.italic));
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Received Fee',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width <= 400
                                          ? 15
                                          : 20,
                                  // color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          Text(('Running Month'),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width <= 400
                                          ? 8
                                          : 12,
                                  // color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                      StreamBuilder(
                        stream: userStatus.toString().contains('SuperAdmin')
                            ? DBHandler.feeHistoryCollection().orderBy('Date').snapshots()
                            : DBHandler.feeHistoryCollectionWithUserUID(
                                    userStatus![2].toString()).orderBy('Date')
                                .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {

                          if(snapshot.hasData) {
                            double totalReceivedFee = 0;



                            for(int count= 0;count < snapshot.data!.docs.length ; count++){
                              String voucherDate = snapshot.data!.docs[count][
                              ModelFeeVoucher.dateKey].toString();
                              var datePicker = DateTime(
                                  int.parse(voucherDate.substring(0, 4)),
                                  int.parse(voucherDate.substring(5, 7)),
                                  int.parse(voucherDate.substring(8, 10)));

                              if(dateToday.month.toString() == datePicker.month.toString()) {
                                totalReceivedFee +=
                                snapshot.data!.docs[count][ModelFeeVoucher
                                    .amountKey];
                              }
                            }
                            return Text(totalReceivedFee.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width <= 400
                                        ? 15
                                        : 20,
                                    // color: Colors.white,
                                    fontStyle: FontStyle.italic));
                          }else{
                            return const CircularProgressIndicator();
                          }},
                      )
                    ],
                  )
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  static Widget monthlyFeeDetails(
      {required String expectedFee,
      required String receivedFee,
      required String shortFee,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Expected Fee',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width <= 400 ? 15 : 20,
                      fontStyle: FontStyle.italic)),
              Text(expectedFee,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width <= 400 ? 15 : 20,
                      fontStyle: FontStyle.italic))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Received Fee',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width <= 400 ? 15 : 20,
                      fontStyle: FontStyle.italic)),
              Text(receivedFee,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width <= 400 ? 15 : 20,
                      fontStyle: FontStyle.italic))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Short Fee',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width <= 400 ? 15 : 20,
                      fontStyle: FontStyle.italic)),
              Text(shortFee,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          MediaQuery.of(context).size.width <= 400 ? 15 : 20,
                      fontStyle: FontStyle.italic))
            ],
          )
        ],
      ),
    );
  }

  static Widget latestVoucher() {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            List<String>? userStatus =
                snapshot.data!.getStringList('getUserInfo');

            return StreamBuilder<QuerySnapshot>(
              stream: userStatus.toString().contains('SuperAdmin')
                  ? DBHandler.feeHistoryCollection().orderBy('Date').snapshots()
                  : DBHandler.feeHistoryCollectionWithUserUID(
                          userStatus![2].toString())
                      .orderBy('Date')
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Something went wrong////////////////////////////////////////////////////');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  var doc = snapshot.data!.docs[snapshot.data!.docs.length - 1];
                  print(
                      '.....................doc...${snapshot.data!.docs.length - 1}...................................');
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .75,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               const Flexible(
                                 child: FittedBox(
                                    child: Text(
                                  'Name :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                              )),
                               ),
                              Flexible(
                                child: FittedBox(
                                  child: Text(
                                    doc[ModelFeeVoucher.studentNameKey],
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const FittedBox(
                                  child: Text(
                                'CNIC :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )),
                              FittedBox(
                                  child: Text(
                                doc[ModelFeeVoucher.cnicKey],
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const FittedBox(
                                  child: Text(
                                'Group Name :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )),
                              FittedBox(
                                  child: Text(
                                doc[ModelFeeVoucher.courseNameKey],
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const FittedBox(
                                  child: Text(
                                'Amount :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )),
                              FittedBox(
                                  child: Text(
                                'PKR.${doc[ModelFeeVoucher.amountKey]}',
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const FittedBox(
                                  child: Text(
                                'Installment :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )),
                              FittedBox(
                                  child: Text(
                                doc[ModelFeeVoucher.installmentKey].toString(),
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const FittedBox(
                                  child: Text(
                                'Date :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )),
                              FittedBox(
                                  child: Text(
                                doc[ModelFeeVoucher.dateKey]
                                    .toString()
                                    .substring(0, 10),
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const FittedBox(
                                  child: Text(
                                'Time :',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              )),
                              FittedBox(
                                  child: Text(
                                doc[ModelFeeVoucher.timeKey],
                                style: const TextStyle(fontSize: 15),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('No Data'));
                }
              },
            );
          } else {
            return const Text('No Data');
          }
        });
  }
}
