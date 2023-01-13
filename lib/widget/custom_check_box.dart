import 'package:flutter/material.dart';

class CheckBoxWidget {
  static Widget customCheckBoxTile(
      {required IconData icon,
      bool? status,
      required String title,
      void Function(bool?)? onChangedValue}) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black12,
            offset: Offset(
              2,
              2,
            ),
            spreadRadius: 2,
            blurRadius: 2)
      ], color: Colors.white),
      child: CheckboxListTile(
          secondary: const Icon(Icons.menu_book_rounded),
          title: Text(title),
          activeColor: Colors.blue.shade400,
          checkColor: Colors.white,
          contentPadding: const EdgeInsets.all(8.0),
          controlAffinity: ListTileControlAffinity.leading,
          value: status,
          onChanged: onChangedValue,),
    );
  }
}
