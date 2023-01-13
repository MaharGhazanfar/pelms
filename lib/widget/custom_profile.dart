import 'package:flutter/material.dart';

class CustomProfileWidget {
  static Widget customProfileText(
      {required String text,
      required String title,
      required BuildContext context}) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 50,

      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 2),
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
        padding: const EdgeInsets.only(left: 12.0),
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width <= 400 ? 15 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.65)),
              ),
              Text(
                ' : ',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width <= 400 ? 16 : 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.65)),
              ),
              Text(

                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width <= 400 ? 15 : 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
