class ModelFeeStructure{
  late String _title;
  late double _payable;
  late List<String> _paidStatus;
  late String _date;
  late List<double> _outStanding;
  late List<double> _payableInstallment;
  late int _maxInstallment;
  late int _minInstallment;


  List<double> get payableInstallment => _payableInstallment;

  set payableInstallment(List<double> value) {
    _payableInstallment = value;
  }

  int get maxInstallment => _maxInstallment;

  set maxInstallment(int value) {
    _maxInstallment = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  static const String titleKey = 'Title';
  static const String payableKey = 'Payable';
  static const String paidStatusKey = 'PaidStatus';
  static const String outStandingKey = 'OutStanding';
  static const String payableInstallmentKey = 'PayableInstallment';
  static const String dateKey = 'Date';
  static const String maxInstallmentKey = 'MaxInstallment';
  static const String minInstallmentKey = 'MinInstallment';

  ModelFeeStructure({
     String title='',
     double payable=0.0,
    List<double> payableInstallment =const [],
     int maxInstallment=0,
     int minInstallment=0,
     List<String> paidStatus=const [],
     List<double> outStanding=const[],
     String date='',
  })  : _title = title,
        _payable = payable,
        _outStanding = outStanding,
        _date = date,
        _payableInstallment = payableInstallment,
        _maxInstallment = maxInstallment,
        _minInstallment = minInstallment,
        _paidStatus = paidStatus;

  Map<String, dynamic> toMap() {
    return {
      titleKey: title,
      payableKey: payable,
      dateKey: date,
      payableInstallmentKey : payableInstallment,
      outStandingKey: outStanding,
      maxInstallmentKey: maxInstallment,
      minInstallmentKey: minInstallment,
      paidStatusKey: paidStatus
    };
  }

  factory ModelFeeStructure.fromMap(Map<String, dynamic> map) {
    return ModelFeeStructure(
        title: map[titleKey],
        payableInstallment:map[payableInstallmentKey],
        payable: map[payableKey],
        paidStatus: map[paidStatusKey],
        maxInstallment: map[maxInstallmentKey],
        minInstallment: map[minInstallmentKey],
        outStanding: map[outStandingKey],
        date: map[dateKey]);
  }


  double get payable => _payable;

  set payable(double value) {
    _payable = value;
  }


  List<String> get paidStatus => _paidStatus;

  set paidStatus(List<String> value) {
    _paidStatus = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }


  List<double> get outStanding => _outStanding;

  set outStanding(List<double> value) {
    _outStanding = value;
  }

  int get minInstallment => _minInstallment;

  set minInstallment(int value) {
    _minInstallment = value;
  }

}
