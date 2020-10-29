
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pollocksschool/enums/user_type.dart';

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
  UserType userType;

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
    this.sections,
    this.userType
  });

  static UserType getUserType(String type){
    if(describeEnum(UserType.STUDENT) == type)
      return UserType.STUDENT;
    else if(describeEnum(UserType.ADMIN) == type)
      return UserType.ADMIN;
    else
      return UserType.TEACHER;
  }

  UserModel.fromJson(Map<String,dynamic> json)
      : this.id = json['id'],
        this.email = json['email'],
        this.branch = json['branch'],
        this.countrycode = json['countrycode'],
        this.creationTime = DateTime.tryParse(json['creationTime'].toString()),
        this.dob = json['dob'],
        this.firstname = json['firstname'],
        this.gender = json['gender'],
        this.lastname = json['lastname'],
        this.lastSignInTime = DateTime.tryParse(json['lastSignInTime'].toString()),
        this.phonenumber = json['phonenumber'],
        this.photourl = json['photourl'],
        this.userType = getUserType(json['usertype']),
//        this.sections =(json['sections'] as List<dynamic>).map((e) => "$e").toList()  ;
        this.sections = json["sections"] != null ? new List<String>.from(json["sections"].map((x) => x.toString())) : List<String>();

}
