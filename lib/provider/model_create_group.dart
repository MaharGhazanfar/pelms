class ModelCreateGroup {
  late String _groupName;

  late String _courseName;

  late String _duration;

  late String _courseFee;

  late String _date;

  late String _startingTime;

  late String _endingTime;

  static const String groupNameKey = 'groupNameKey';
  static const String courseNameKey = 'courseNameKey';
  static const String durationKey = 'durationKey';
  static const String courseFeeKey = 'courseFeeKey';
  static const String dateKey = 'dateKey';
  static const String startingTimeKey = 'startingTimeKey';
  static const String endingTimeKey = 'endingTimeKey';



  ModelCreateGroup(
      {required String groupName,
        required String courseName,
        required String duration,
        required String courseFee,
        required String date,
        required String startingTime,
        required String endingTime})
      : _groupName = groupName,
        _courseName = courseName,
        _startingTime = startingTime,
        _endingTime = endingTime,
        _date = date,
        _courseFee = courseFee,
        _duration = duration;


  String get groupName => _groupName;

  set groupName(String value) {
    _groupName = value;
  }

  Map<String, dynamic> toMap() {
    return {
      groupNameKey: groupName,
      courseNameKey: courseName,
      durationKey: duration,
      dateKey: _date,
      endingTimeKey: endingTime,
      courseFeeKey: courseFee,
      startingTimeKey: startingTime,
    };
  }

  factory ModelCreateGroup.fromMap(Map<String, dynamic> map) {
    return ModelCreateGroup(
        groupName: map[groupNameKey],
        courseName: map[courseNameKey],
        duration: map[durationKey],
        courseFee: map[courseFeeKey],
        date: map[dateKey],
        startingTime: map[startingTimeKey],
        endingTime: map[endingTimeKey]);
  }


  @override
  String toString() {
    return 'ModelAddStudent{_groupName: $_groupName, _courseName: $_courseName, _duration: $_duration, _courseFee: $_courseFee, _date: $_date, _startingTime: $_startingTime, _endingTime: $_endingTime}';
  }

  String get courseName => _courseName;

  set courseName(String value) {
    _courseName = value;
  }

  String get duration => _duration;

  set duration(String value) {
    _duration = value;
  }

  String get courseFee => _courseFee;

  set courseFee(String value) {
    _courseFee = value;
  }

  String get startingTime => _startingTime;

  set startingTime(String value) {
    _startingTime = value;
  }

  String get endingTime => _endingTime;

  set endingTime(String value) {
    _endingTime = value;
  }
}
