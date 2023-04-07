class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? lastname;
  String? age;
  String? jobStatus;
  String? civilStatus;

  UserModel(
      {this.uid,
      this.email,
      this.firstname,
      this.lastname,
      this.age,
      this.jobStatus,
      this.civilStatus});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstname: map['firstname'],
        lastname: map['lastname'],
        age: map['age'],
        jobStatus: map['jobStatus'],
        civilStatus: map['civilStatus']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'jobStatus': jobStatus,
      'civilStatus': civilStatus
    };
  }
}
