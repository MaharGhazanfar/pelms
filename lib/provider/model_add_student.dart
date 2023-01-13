import 'package:flutter/cupertino.dart';

class ModelAddStudent extends ChangeNotifier{
  late String _name;

  late String _fatherName;

  late String _phoneNumber;

  late String _gMail;

  late String _cnic;

  late String _address;

  late String _gender;

  static const String nameKey = 'nameKey';
  static const String fatherNameKey = 'fatherNameKey';
  static const String phoneNumberKey = 'phoneNumberKey';
  static const String gMailKey = 'gMailKey';
  static const String cnicKey = 'cnicKey';
  static const String addressKey = 'addressKey';
  static const String genderKey = 'genderKey';

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  ModelAddStudent(
      { String name = '',
       String fatherName ='',
       String phoneNumber='',
       String cnic='',
       String gMail='',
       String address='',
       String gender='male'})
      : _name = name,
        _fatherName = fatherName,
        _address = address,
        _gender = gender,
        _cnic = cnic,
        _gMail = gMail,
        _phoneNumber = phoneNumber;

  String get fatherName => _fatherName;

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get cnic => _cnic;

  set cnic(String value) {
    _cnic = value;
  }

  String get gMail => _gMail;

  set gMail(String value) {
    _gMail = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set fatherName(String value) {
    _fatherName = value;
  }

  Map<String, dynamic> toMap() {
    return {
      nameKey: name,
      fatherNameKey: fatherName,
      phoneNumberKey: phoneNumber,
      cnicKey: cnic,
      genderKey: gender,
      gMailKey: gMail,
      addressKey: address,
    };
  }

  factory ModelAddStudent.fromMap(Map<String, dynamic> map) {
    return ModelAddStudent(
        name: map[nameKey],
        fatherName: map[fatherNameKey],
        phoneNumber: map[phoneNumberKey],
        cnic: map[cnicKey],
        gMail: map[gMailKey],
        address: map[addressKey],
        gender: map[genderKey]);
  }

  @override
  String toString() {
    return 'ModelAddStudent{_name: $_name, _fatherName: $_fatherName, _phoneNumber: $_phoneNumber, _gMail: $_gMail, _cnic: $_cnic, _address: $_address, _gender: $_gender}';
  }
}
