


class CompanyEntity{
  int? id;
  String? name;
  String? city;
  int? activity;
  String? address;

  CompanyEntity({
    this.id,
    this.name,
    this.city,
    this.activity,
    this.address
  });




  CompanyEntity copyWith({
    int? id,
    String? name,
    String? city,
    int? activity,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      activity: activity ?? this.activity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CompanyEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              city == other.city &&
              activity == other.activity;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ city.hashCode ^ activity.hashCode;




}