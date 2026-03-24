part of 'add_client_bloc.dart';



class AddClientState {

  AppStatus? fetchDataStatus;
  AppStatus? addClientStatus;
  String? error;
  List<TypeClientEntity>? types;
  List<ActivityClientEntity>? activities;
  bool? isOffline;
  TypeClientEntity? selectedType;
  ActivityClientEntity? selectedActivity;

  AddClientState({
    this.fetchDataStatus,
    this.error,
    this.types,
    this.activities,
    this.isOffline,
    this.selectedType,
    this.selectedActivity,
    this.addClientStatus
  });

  AddClientState copyWith({
    AppStatus? fetchDataStatus,
    AppStatus? addClientStatus,
    String? error,
    List<TypeClientEntity>? types,
    List<ActivityClientEntity>? activities,
    bool? isOffline,
    TypeClientEntity? selectedType,
    ActivityClientEntity? selectedActivity,

  }) {
    return AddClientState(
      fetchDataStatus: fetchDataStatus ?? this.fetchDataStatus,
      error: error ,
      types: types ?? this.types,
      activities: activities ?? this.activities,
      isOffline: isOffline ,
      selectedType: selectedType ?? this.selectedType,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      addClientStatus: addClientStatus
    );
  }
}

