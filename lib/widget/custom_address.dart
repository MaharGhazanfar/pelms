import 'package:flutter/material.dart';

class CustomAddressWidget {
  static Widget customAddress(String? titleName, BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(15),
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
      child: TextFormField(
        maxLines: 2,
        enabled: false,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Address : ',
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width <= 400 ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.65)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text(
                    titleName!,
                    style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width <= 400 ? 12 : 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
