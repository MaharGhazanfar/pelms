import 'package:flutter/material.dart';

class CustomVoucher {
  static Widget customVoucher({
    required String date,
    required String time,
    required BuildContext context,
    required String studentName,
    required String courseName,
    required String cnic,
    required String installment,
    required String amount,
    required void Function()? onPressed,

  }) {
    return Material(
      color: Colors.transparent,
      elevation: 30,
      child: Container(
        height: MediaQuery.of(context).size.height * .40,
        width: MediaQuery.of(context).size.width * .80,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue, width: 3),
            borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child:  FittedBox(
                        child: Text(
                          'Name :',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                  ),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        studentName,
                      //  textAlign: TextAlign.start,
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
                   const Flexible(
                     child: FittedBox(
                        child: Text(
                          'CNIC :',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                   ),
                  Flexible(
                    child: FittedBox(
                        child: Text(
                          cnic,
                          style: const TextStyle(fontSize: 15),
                        )),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const FittedBox(
                      child: Text(
                        'Group Name :',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                  FittedBox(
                      child: Text(
                        time,
                        style: const TextStyle(fontSize: 15),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: onPressed, child: const Text('Submit')),
                    TextButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: const Text('Cancel')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
