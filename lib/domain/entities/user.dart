


class UserEntity{
  int? id;
  int? idCamion;
  String? firstName;
  String? lastName;
  String? email;
  String? token;

  UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.token,
    this.idCamion
  });


  UserEntity copyWith({
    int? id,
    int? idCamion,
    String? firstName,
    String? lastName,
    String? email,
    String? token,
  }) {
    return UserEntity(
      id: id ?? this.id,
      idCamion: idCamion ?? this.idCamion,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}