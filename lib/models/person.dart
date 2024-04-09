class Person {
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? maritalStatus;
  String? dob;
  String? ssn;
  String? primaryDoctorName;

  Person({
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.maritalStatus,
    this.dob,
    this.ssn,
    this.primaryDoctorName,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'dob': dob,
      'ssn': ssn,
      'primaryDoctorName': primaryDoctorName,
    };
  }
}