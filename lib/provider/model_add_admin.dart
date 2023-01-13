class ModelAddAdmin {
  late String _name;

  late String _salary;

  late String _phoneNumber;

  late String _gMail;

  late String _cnic;

  late String _address;

  late String _gender;

  static const String nameKey = 'nameKey';
  static const String salaryKey = 'salaryKey';
  static const String phoneNumberKey = 'phoneNumberKey';
  static const String gMailKey = 'gMailKey';
  static const String cnicKey = 'cnicKey';
  static const String addressKey = 'addressKey';
  static const String genderKey = 'genderKey';

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  ModelAddAdmin(
      {required String name,
        required String salary,
        required String phoneNumber,
        required String cnic,
        required String gMail,
        required String address,
        required String gender})
      : _name = name,
        _salary = salary,
        _address = address,
        _gender = gender,
        _cnic = cnic,
        _gMail = gMail,
        _phoneNumber = phoneNumber;

  String get salary => _salary;

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
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

  set salary(String value) {
    _salary = value;
  }

  Map<String, dynamic> toMap() {
    return {
      nameKey: name,
      salaryKey: salary,
      phoneNumberKey: phoneNumber,
      cnicKey: cnic,
      genderKey: gender,
      gMailKey: gMail,
      addressKey: address,
    };
  }

  factory ModelAddAdmin.fromMap(Map<String, dynamic> map) {
    return ModelAddAdmin(
        name: map[nameKey],
        salary: map[salaryKey],
        phoneNumber: map[phoneNumberKey],
        cnic: map[cnicKey],
        gMail: map[gMailKey],
        address: map[addressKey],
        gender: map[genderKey]);
  }

  @override
  String toString() {
    return 'ModelAddStudent{_name: $_name, _salary: $_salary, _phoneNumber: $_phoneNumber, _gMail: $_gMail, _cnic: $_cnic, _address: $_address, _gender: $_gender}';
  }
}
