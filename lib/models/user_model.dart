class UserModel {

  String branch;
  List<String> sections;
  String countrycode;
  DateTime creationTime;
  String dob;
  String email;
  String firstname;
  String gender;
  String id;
  DateTime lastSignInTime;
  String lastname;
  String phonenumber;
  String photourl;

  UserModel({
    this.id,
    this.email,
    this.branch,
    this.countrycode,
    this.creationTime,
    this.dob,
    this.firstname,
    this.gender,
    this.lastname,
    this.lastSignInTime,
    this.phonenumber,
    this.photourl,
    this.sections
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.email = json['email'],
        this.branch = json['branch'],
        this.countrycode = json['countrycode'],
        this.creationTime = json['creationTime'] as DateTime,
        this.dob = json['dob'],
        this.firstname = json['firstname'],
        this.gender = json['gender'],
        this.lastname = json['lastname'],
        this.lastSignInTime = json['lastSignInTime'] as DateTime,
        this.phonenumber = json['phonenumber'],
        this.photourl = json['photourl'],
        this.sections = json['sections'] as List<String>;
}
