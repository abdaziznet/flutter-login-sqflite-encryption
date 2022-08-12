class UserModel {
  int? UserId;
  String? UserName;
  String? Email;
  String? Password;

  UserModel(
      {this.UserId = 0,
      required this.UserName,
      required this.Email,
      required this.Password});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_name': UserName,
      'email': Email,
      'password': Password,
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    UserId = map['user_Id'];
    UserName = map['user_name'];
    Email = map['email'];
    Password = map['password'];
  }
}
