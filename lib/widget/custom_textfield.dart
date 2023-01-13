import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWidget {
  static Widget customTextField(
      {required TextEditingController controller,
      required IconData icon,
      required String titleName,
      required FormFieldValidator<String>? validate,
      TextInputType textInputType = TextInputType.text,
      int? maxLength,
      List<TextInputFormatter>? inputFormatters,
      String? prefixText}) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [
        BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            offset: const Offset(
              0.5,
              0.5,
            ),
            spreadRadius: 1,
            blurRadius: 3)
      ]),
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters,
        validator: validate,
        keyboardType: textInputType,
        maxLength: maxLength,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            filled: true,
            prefixText: prefixText,
            prefixIconColor: Colors.red,
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            label: Text(titleName),
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey, width: 1)),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  static Widget dropdownButton2({
    required List items,
    double? dropDownMaxHeight,
    required BuildContext context,
    void Function(String?)? onChanged,
    void Function(String?)? onSaved,
    required String titleName,
    required String initialValue,
    FormFieldValidator<String>? validate,
  }) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [
        BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            offset: const Offset(
              0.5,
              0.5,
            ),
            spreadRadius: 1,
            blurRadius: 3)
      ]),
      child: DropdownButtonFormField2(
          value: initialValue,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            label: Text(
              titleName,
            ),

            labelStyle: const TextStyle(color: Colors.black),
            isDense: true,
            prefixIcon: const Icon(
              Icons.confirmation_num_outlined,
              color: Colors.black,
              size: 25,
            ),
            filled: true,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey, width: 1)),
            errorBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey, width: 1),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            fillColor: Colors.white,
            //contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          alignment: Alignment.center,
          isExpanded: false,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          iconSize: 25,
          buttonHeight: 50,
          scrollbarAlwaysShow: true,
          scrollbarRadius: const Radius.circular(50),
          scrollbarThickness: 10,
          buttonPadding: const EdgeInsets.only(left: 20, right: 10),
          dropdownMaxHeight: 300,
          dropdownOverButton: false,
          dropdownPadding: const EdgeInsets.only(
            bottom: 20,
          ),
          dropdownDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                    ),
                  ))
              .toList(),
          validator: validate,
          onChanged: onChanged,
          onSaved: onSaved),
    );
  }
}
