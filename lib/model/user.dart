class User {
  late final int? userId;
  late final String? username;
  late final String? password;
  late final String? email;
  late final int? gender;

  User({this.userId,this.username, this.password, this.email, this.gender});

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'email': email,
        'gender': gender
      };
}
