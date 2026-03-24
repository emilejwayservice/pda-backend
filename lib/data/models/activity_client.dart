


import 'package:pda/domain/entities/activity_client.dart';

class ActivityClientModel{
  int? id;
  String? code;
  String? label;

  ActivityClientModel({
    this.id,
    this.code,
    this.label,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'code': this.code,
      'label': this.label,
    };
  }

  factory ActivityClientModel.fromJson(Map<String, dynamic> json) {
    return ActivityClientModel(
      id: json['id'],
      code: json['code'] ,
      label: json['label'] ,
    );
  }

  ActivityClientEntity toEntity(){
    return ActivityClientEntity(
      id: id,
      label: label,
      code: code
    );
  }


}
