class ModelFeeVoucher {
  late String _studentName;

  late String _courseName;

  late String _cnic;

  late double _amount;

  late String _installment;

  late String _date;

  late String _time;



  static const String studentNameKey = 'StudentName';
  static const String installmentKey = 'Installment';
  static const String courseNameKey = 'CourseName';
  static const String cnicKey = 'CNIC';
  static const String amountKey = 'AmountKey';
  static const String dateKey = 'Date';
  static const String timeKey = 'Time';


  String get installment => _installment;

  set installment(String value) {
    _installment = value;
  }

  ModelFeeVoucher(
      {required String studentName,
        required String courseName,
        required String installment,
        required String cnic,
        required double amount,
        required String date,
        required String time})
      : _studentName = studentName,
        _courseName = courseName,
        _time = time,
        _date = date,
        _installment = installment,
        _amount = amount,
        _cnic = cnic;



  Map<String, dynamic> toMap() {
    return {
      studentNameKey: studentName,
      courseNameKey: courseName,
      cnicKey: cnic,
      dateKey: date,
      installmentKey : installment,
      timeKey: time,
      amountKey: amount,
    };
  }


  factory ModelFeeVoucher.fromMap(Map<String, dynamic> map) {
    return ModelFeeVoucher(
        studentName: map[studentNameKey],
        courseName: map[courseNameKey],
        installment: map[installmentKey],
        cnic: map[cnicKey],
        amount: map[amountKey],
        date: map[dateKey],
        time: map[timeKey]);
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  String get cnic => _cnic;

  set cnic(String value) {
    _cnic = value;
  }

  String get courseName => _courseName;

  set courseName(String value) {
    _courseName = value;
  }

  String get studentName => _studentName;

  set studentName(String value) {
    _studentName = value;
  }
}
