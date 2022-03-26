class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? dateOfBirth;

  UserModel({this.uid, this.email, this.firstName, this.secondName, this.dateOfBirth});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
        dateOfBirth: map['dateOfBirth']

    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'dateOfBirth': dateOfBirth,
    };
  }
}