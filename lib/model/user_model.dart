class UserModel {
  String? uid;
  String? email;
  String? firstname;
  String? secondname;
  String? category;//Added By Sanjay as part of user update

  UserModel({this.uid, this.email, this.firstname, this.secondname, this.category});

  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstname: map['firstname'],
      secondname: map['secondname'],
      category: map['category'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'secondname': secondname,
      'category': category
    };
  }
}
