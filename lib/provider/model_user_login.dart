class ModelUserLogin {
  late String _userName;
  late String _password;

  static const String userNameKey = 'UserName';
  static const String passwordKey = 'Password';

  ModelUserLogin({required String userName, required String password})
      : _userName = userName,
        _password = password;

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  Map<String, dynamic> toMap() {
    return {
      userNameKey: userName,
      passwordKey: password,
    };
  }

  factory ModelUserLogin.fromMap(Map<String, dynamic> map) {
    return ModelUserLogin(
      userName: map[userNameKey],
      password: map[passwordKey],
    );
  }

}
