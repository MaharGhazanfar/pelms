class ModelAddInquiry {
  late String _name;

  late String _fatherName;
  late String _confirmationStatus;

  String get confirmationStatus => _confirmationStatus;

  set confirmationStatus(String value) {
    _confirmationStatus = value;
  }

  late String _phoneNumber;

  late String _gMail;
  late String _cnic;

  String get cnic => _cnic;

  set cnic(String value) {
    _cnic = value;
  }

  late String _aboutInquiry;

  static const String nameKey = 'nameKey';
  static const String confirmationStatusKey = 'ConfirmationStatus';
  static const String fatherNameKey = 'fatherNameKey';
  static const String phoneNumberKey = 'phoneNumberKey';
  static const String cnicKey = 'cnicKey';
  static const String gMailKey = 'gMailKey';
  static const String aboutInquiryKey = 'aboutInquiryKey';

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  ModelAddInquiry({
    required String name,
    required String fatherName,
    required String confirmationValue,
    required String cnic,
    required String phoneNumber,
    required String aboutInquiry,
    required String gMail,
  })  : _name = name,
        _fatherName = fatherName,
        _cnic = cnic,
        _confirmationStatus = confirmationValue,
        _aboutInquiry = aboutInquiry,
        _gMail = gMail,
        _phoneNumber = phoneNumber;

  String get fatherName => _fatherName;

  String get aboutInquiry => _aboutInquiry;

  set aboutInquiry(String value) {
    _aboutInquiry = value;
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
      confirmationStatusKey: confirmationStatus,
      cnicKey: cnic,
      aboutInquiryKey: aboutInquiry,
      gMailKey: gMail,
    };
  }

  factory ModelAddInquiry.fromMap(Map<String, dynamic> map) {
    return ModelAddInquiry(
      name: map[nameKey],
      cnic: map[cnicKey],
      confirmationValue: map[confirmationStatusKey],
      aboutInquiry: map[aboutInquiryKey],
      fatherName: map[fatherNameKey],
      phoneNumber: map[phoneNumberKey],
      gMail: map[gMailKey],
    );
  }

  @override
  String toString() {
    return 'ModelAddInquiry{_name: $_name, _fatherName: $_fatherName, _phoneNumber: $_phoneNumber, _gMail: $_gMail, _cnic: $_cnic, _aboutInquiry: $_aboutInquiry, _confirmationStatus : $_confirmationStatus}';
  }
}
