
import 'package:pda/domain/entities/status.dart';

class StatusModel{
  int? id;
  String? status;
  String? color;

  StatusModel({
    this.id,
    this.status,
    this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'status': this.status,
      'color': this.color,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      status: json['status'],
      color: json['color'],
    );
  }
  StatusEntity toEntity(){
    return StatusEntity(
      status: status,
      id: id,
      color:color
    );
  }
}