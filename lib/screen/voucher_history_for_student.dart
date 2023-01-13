import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../provider/model_fee_voucher.dart';
import '../util/firebase_db_handler.dart';

class VoucherHistoryForStudent extends StatefulWidget {
  final String cnic;
  final String userUID;

  const VoucherHistoryForStudent(
      {Key? key, required this.userUID, required this.cnic})
      : super(key: key);

  @override
  _VoucherHistoryForStudentState createState() =>
      _VoucherHistoryForStudentState();
}

class _VoucherHistoryForStudentState extends State<VoucherHistoryForStudent> {
  final PageController _pageController =
      PageController(viewportFraction: .40, initialPage: 1);

  late Stream<QuerySnapshot> _feeHistoryStreamForStudent;

  @override
  void initState() {
    super.initState();
    _feeHistoryStreamForStudent =
        DBHandler.feeHistoryCollectionWithUserUID(widget.userUID).snapshots();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Student details'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: kIsWeb
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: _feeHistoryStreamForStudent,
            builder:
                (context, AsyncSnapshot<QuerySnapshot> snapshotPerStudent) {
              if (snapshotPerStudent.hasError) {
                return const Text(
                    'Something went wrong////////////////////////////////////////////////////');
              }
              if (snapshotPerStudent.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                var list = [];
                for (int i = 0; i < snapshotPerStudent.data!.docs.length; i++) {
                  var singleDoc = snapshotPerStudent.data!.docs[i];
                  if (singleDoc[ModelFeeVoucher.cnicKey] == widget.cnic) {
                    list.add(singleDoc);
                  }
                }

                return PageView.builder(
                  itemCount: list.length,
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    var singleDoc = list[index];

                    return _builder(
                        index: index,
                        studentName: singleDoc[ModelFeeVoucher.studentNameKey],
                        installment: singleDoc[ModelFeeVoucher.installmentKey],
                        studentCnic: singleDoc[ModelFeeVoucher.cnicKey],
                        time: singleDoc[ModelFeeVoucher.timeKey],
                        courseName: singleDoc[ModelFeeVoucher.courseNameKey],
                        amount: singleDoc[ModelFeeVoucher.amountKey].toString(),
                        date: singleDoc[ModelFeeVoucher.dateKey]);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _builder(
      {required int index,
      required String studentName,
      required String installment,
      required String studentCnic,
      required String time,
      required String courseName,
      required String amount,
      required String date}) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 1.0;

          if (_pageController.position.haveDimensions) {
            value = (_pageController.page! - index);

            if (value >= 0) {
              double _lowerLimit = 0;
              double _upperLimit = 2;

              value =
                  (_upperLimit - (value.abs() * (_upperLimit - _lowerLimit)))
                      .clamp(_lowerLimit, _upperLimit);
              value = _upperLimit - value;
              value *= -0;
            }
          } else {
            if (index == 0) {
              value = 0;
            } else if (index == 1) {
              value = -0;
            }
          }

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(value),
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.all(16.0), child: child),
          );
        },
        child: Container(
          height: 300,
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.blue.shade400, width: 3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(2, 2),
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 3),
                BoxShadow(
                    offset: Offset(-2, -3),
                    color: Colors.white10,
                    blurRadius: 5,
                    spreadRadius: 3)
              ]),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FittedBox(
                            child: Text(
                          'Name :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        SizedBox(
                            width: 140,
                            child: Text(
                              studentName,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(fontSize: 12),
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const FittedBox(
                            child: Text(
                          'CNIC :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        FittedBox(
                            child: Text(
                          studentCnic,
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        FittedBox(
                            child: Text(
                          courseName,
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        FittedBox(
                            child: Text(
                          'PKR.$amount',
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        FittedBox(
                            child: Text(
                          installment,
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        FittedBox(
                            child: Text(
                          date,
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
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                        FittedBox(
                            child: Text(
                          time,
                          style: const TextStyle(fontSize: 15),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
