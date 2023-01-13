import 'package:flutter/material.dart';

import '../provider/model_add_student.dart';

class SelectMultipleItemsForStudent extends ChangeNotifier {
  bool _isSelectionMode = false;
  bool _isNotSearching = true;

  List list = [];
  List<Map<String, dynamic>>? _dataList = [];
  List<Map<String, dynamic>> _filterList = [];
  Map<int, bool> _selectedFlag = {};

  List<Map<String, dynamic>> get dataList => _dataList!;

  set dataList(List<Map<String, dynamic>> value) {
    _dataList = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filterList => _filterList;

  set filterList(List<Map<String, dynamic>> value) {
    _filterList = value;
    notifyListeners();
  }

  bool get isSelectionMode => _isSelectionMode;

  set isSelectionMode(bool value) {
    _isSelectionMode = value;
    notifyListeners();
  }

  bool get isNotSearching => _isNotSearching;

  set isNotSearching(bool value) {
    _isNotSearching = value;
    notifyListeners();
  }

  Map<int, bool> get selectedFlag => _selectedFlag;

  set selectedFlag(Map<int, bool> value) {
    _selectedFlag = value;
    notifyListeners();
  }

  void onTap({
    required bool isSelected,
    required int index,
    required void Function(void Function()) setState,
    required Map<String, dynamic> map,
  }) {
    if (isSelectionMode) {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
      if (selectedFlag[index]!) {
        setState(() {
          list.add(map);
        });
      } else {
        setState(() {
          list.removeAt(index);
        });
      }
    } else {
      // Open Detail Page
    }
  }

  void onLongPress({
    required bool isSelected,
    required int index,
    required void Function(void Function()) setState,
    required Map<String, dynamic> map,
  }) {
    selectedFlag[index] = !isSelected;
    isSelectionMode = selectedFlag.containsValue(true);

    setState(() {
      list.clear();
      list.add(map);
    });
  }

  Widget buildSelectIcon(
      {required bool isSelected, required BuildContext context}) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
        size: MediaQuery.of(context).size.width > 400 ? 35 : 30,
      );
    } else {
      return CircleAvatar(
        radius: MediaQuery.of(context).size.width > 400 ? 25 : 20,
        backgroundColor: Colors.blue,
        child: Center(
          child: Icon(
            Icons.person,
            size: MediaQuery.of(context).size.width > 400 ? 35 : 30,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Widget buildSelectIconForGroups(
      {required bool isSelected, required BuildContext context}) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
        size: MediaQuery.of(context).size.width > 400 ? 35 : 30,
      );
    } else {
      return CircleAvatar(
        radius: MediaQuery.of(context).size.width > 400 ? 25 : 20,
        backgroundColor: Colors.blue,
        child: Center(
          child: Icon(
            Icons.group_outlined,
            size: MediaQuery.of(context).size.width > 400 ? 35 : 30,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  Widget? buildSelectAllButton(
      {required void Function(void Function()) setState}) {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    if (isSelectionMode) {
      return IconButton(
        onPressed: () {
          bool isFalseAvailable = selectedFlag.containsValue(false);
          selectedFlag.updateAll((key, value) => isFalseAvailable);
          isSelectionMode = selectedFlag.containsValue(true);
          list.clear();
          list.addAll(filterList);
          setState(() {});
        },
        icon: Icon(
          isFalseAvailable ? Icons.select_all : Icons.check_box,
          color: Colors.white,
        ),
      );
    } else {
      setState(() {});
      return null;
    }
  }

  Widget appBarTitle(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget appBarTextField(
      {required TextEditingController searchController,
      //required String searchingFor,
      required void Function(void Function()) setState}) {
    return SizedBox(
      height: 40,
      child: TextField(
        autofocus: true,
        controller: searchController,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        onChanged: (value) {
          // if (searchingFor == 'Inquiry Details') {
          //   getSearchListForInquiryDetails(value, setState: setState);
          // } else if (searchingFor == 'Fee History') {
          //   getSearchListForFeeHistory(value, setState: setState);
          // } else if (searchingFor == 'Group Details') {
          //   getSearchListForGroupDetails(value, setState: setState);
          // }else{
          //   print('student details search');
          getSearchListForStudentDetails(value, setState: setState);
          // }
        },
        decoration: InputDecoration(
            isDense: true,
            fillColor: Colors.blue.shade50,
            filled: true,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.black54,
              ),
            ),
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
            suffixIcon: IconButton(
              tooltip: 'Clear',
              splashRadius: 20,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  searchController.text = '';
                  filterList = dataList;
                });
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.clear,
                  color: Colors.black54,
                ),
              ),
            )),
      ),
    );
  }

  Widget? buildLeading() {
    return IconButton(
        onPressed: () {
          list.clear();
          selectedFlag.updateAll((key, value) => false);
          isSelectionMode = false;
          isNotSearching = true;
        },
        icon: const Icon(Icons.arrow_back));
  }

  // void getSearchListForInquiryDetails(String value,
  //     {required void Function(void Function()) setState}) {
  //   List<Map<String, dynamic>> tempList = [];
  //   for (Map<String, dynamic> element in dataList) {
  //     if (element[ModelAddInquiry.cnicKey]
  //         .toLowerCase()
  //         .contains(value.toLowerCase()) ||
  //         element[ModelAddInquiry.nameKey]
  //             .toLowerCase()
  //             .contains(value.toLowerCase()) ||
  //         element[ModelAddInquiry.phoneNumberKey]
  //             .toLowerCase()
  //             .contains(value.toLowerCase()) ||
  //         element[ModelAddInquiry.confirmationStatusKey]
  //             .toLowerCase()
  //             .contains(value.toLowerCase())) {
  //       tempList.add(element);
  //     }
  //   }
  //   _filterList = tempList;
  //   notifyListeners();
  // }
  //
  // void getSearchListForFeeHistory(String value ,
  //     {required void Function(void Function()) setState}) {
  //   List<Map<String, dynamic>> tempList = [];
  //   for (Map<String, dynamic> element in dataList) {
  //     if (element[ModelFeeVoucher.cnicKey]
  //         .toLowerCase()
  //         .contains(value.toLowerCase()) ||
  //         element[ModelFeeVoucher.studentNameKey]
  //             .toLowerCase()
  //             .contains(value.toLowerCase()) ||
  //         element[ModelFeeVoucher.courseNameKey]
  //             .toLowerCase()
  //             .contains(value.toLowerCase()) ||
  //         element[ModelFeeVoucher.dateKey]
  //             .toLowerCase()
  //             .contains(value.toLowerCase())) {
  //       tempList.add(element);
  //     }
  //   }
  //   _filterList = tempList;
  //   notifyListeners();
  // }
  //
  // void getSearchListForGroupDetails(String value,
  //     {required void Function(void Function()) setState}) {
  //   List<Map<String, dynamic>> tempList = [];
  //   for (Map<String, dynamic> element in dataList) {
  //     if (element[ModelCreateGroup.groupNameKey]
  //         .toLowerCase()
  //         .contains(value.toLowerCase()) ||
  //         element[ModelCreateGroup.courseNameKey]
  //             .toLowerCase()
  //             .contains(value.toLowerCase())) {
  //       tempList.add(element);
  //     }
  //   }
  //   _filterList = tempList;
  //   notifyListeners();
  // }

  void getSearchListForStudentDetails(String value,
      {required void Function(void Function()) setState}) {
    List<Map<String, dynamic>> tempList = [];
    for (Map<String, dynamic> element in dataList) {
      if (element[ModelAddStudent.nameKey]
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element[ModelAddStudent.cnicKey]
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element[ModelAddStudent.phoneNumberKey]
              .toLowerCase()
              .contains(value.toLowerCase()) ||
          element[ModelAddStudent.genderKey]
              .toLowerCase()
              .contains(value.toLowerCase())) {
        tempList.add(element);
      }
    }
    _filterList = tempList;
    notifyListeners();
  }

// void _selectAll() {
//   bool isFalseAvailable = selectedFlag.containsValue(false);
//   selectedFlag.updateAll((key, value) => isFalseAvailable);
//   isSelectionMode = selectedFlag.containsValue(true);
//   list.clear();
//   list.addAll(dataList);
// }
}
