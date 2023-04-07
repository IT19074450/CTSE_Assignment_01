class ProblemSetModel {
  String? timestamp;
  String? problem;
  String? username;
  String? age;
  String? jobStatus;
  String? civilStatus;

  ProblemSetModel(
      {this.problem,
      this.username,
      this.age,
      this.timestamp,
      this.jobStatus,
      this.civilStatus});

  factory ProblemSetModel.fromMap(map) {
    return ProblemSetModel(
        age: map['age'],
        problem: map['problem'],
        username: map['username'],
        timestamp: map['timestamp'],
        jobStatus: map['jobStatus'],
        civilStatus: map['civilStatus']);
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'problem': timestamp,
      'username': username,
      'timestamp': timestamp,
      'jobStatus': jobStatus,
      'civilStatus': civilStatus
    };
  }
}
