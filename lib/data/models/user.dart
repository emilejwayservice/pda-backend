

import 'package:pda/domain/entities/user.dart';

class UserModel{
  int? id;
  int? idCamion;
  String? firstName;
  String? lastName;
  String? email;
  String? token;
  String? password;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.token,
    this.password,
    this.idCamion
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
      'token': this.token,
      'password':password
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ,
      firstName: map['firstName'],
      lastName: map['lastName'] ,
      email: map['email'],
      token: map['token'] ,
      idCamion: map['idCamion']
    );
  }

  UserEntity toEntity()=>UserEntity(
    lastName: lastName,
    firstName: firstName,
    id: id,
    token: token,
    email: email,
    idCamion: idCamion
  );

}