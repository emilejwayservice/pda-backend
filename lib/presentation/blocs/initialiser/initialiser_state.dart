part of 'initialiser_cubit.dart';

class InitialiserState {

  AppStatus? fetchData;
  String? error;
  UserEntity? currentUser;
  List<CompanyEntity>? companies;
  bool? isOffline;
  bool? isAuth;
  String? destination;

  InitialiserState({
    this.fetchData,
    this.error,
    this.currentUser,
    this.companies,
    this.isOffline,
    this.destination,
    this.isAuth
  });
  InitialiserState.empty();

  InitialiserState copyWith({
    AppStatus? fetchData,
    String? error,
    UserEntity? currentUser,
    List<CompanyEntity>? companies,
    bool? isOffline,
    String? destination,
    bool? isAuth
  }) {
    return InitialiserState(
      fetchData: fetchData ?? this.fetchData,
      error: error ,
      currentUser: currentUser ?? this.currentUser,
      companies: companies ?? this.companies,
      isOffline: isOffline ,
      destination: destination ?? this.destination,
      isAuth: isAuth
    );
  }
}

