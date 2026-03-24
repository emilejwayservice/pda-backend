import 'package:bloc/bloc.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/core/utils/set_repository.dart';
import 'package:pda/domain/entities/user.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/exceptions/unauthenticated_exception.dart';
import 'package:pda/domain/repository/repository.dart';

import '../../../domain/entities/company.dart';
import '../../../routes.dart';

part 'initialiser_state.dart';

class InitialiserCubit extends Cubit<InitialiserState> {
  InitialiserCubit() : super(InitialiserState.empty());


  void fetchData()async{
    SharedPrefService sharedPrefService=Dependencies.get<SharedPrefService>();
    try{
      emit(state.copyWith(fetchData: AppStatus.loading));
      bool isTokenExist=sharedPrefService.contains(SharedPrefService.token);
      Repository repository=Dependencies.get<Repository>();
      String destination;
      if(isTokenExist){
        UserEntity userEntity=await repository.getCurrentUser();
        destination=Routes.home;
        Dependencies.put(userEntity);
      }else{
        List<CompanyEntity> companies=await repository.getCompanies();
        destination=Routes.login;
        Dependencies.put(companies);
      }
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(fetchData: AppStatus.success,destination: destination));
    }on NetworkConnectivityException catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error,isOffline: true));
      rethrow;
    }on UnAuthenticatedException catch(ex){
      sharedPrefService.removeRecord(SharedPrefService.token);
      setRepository();
      fetchData();
    }catch(ex){
      emit(state.copyWith(fetchData: AppStatus.error));
      rethrow;
    }
  }


}
