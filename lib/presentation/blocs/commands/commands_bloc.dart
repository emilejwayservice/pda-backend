import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pda/core/constants/enums/app_status.dart';
import 'package:pda/core/dependencies/dependencies.dart';
import 'package:pda/core/services/shared_pref_service.dart';
import 'package:pda/domain/exceptions/network_connectivity_exception.dart';
import 'package:pda/domain/repository/repository.dart';

import '../../../domain/entities/command.dart';
import '../core_bloc/core_bloc.dart';

part 'commands_event.dart';
part 'commands_state.dart';

class CommandsBloc extends Bloc<CommandsEvent, CommandsState> {

  late StreamSubscription<CoreState> streamSubscription;

  CommandsBloc() : super(CommandsState()) {
    on<FetchCommands>(_fetchCommands);
    CoreBloc coreBloc=Dependencies.get<CoreBloc>();
    streamSubscription=coreBloc.stream.listen(listener);
  }

  FutureOr<void> _fetchCommands(FetchCommands event, Emitter<CommandsState> emit) async{
      try{
        emit(state.copyWith(fetchDataStatus: AppStatus.loading));
        Repository repository=Dependencies.get<Repository>();
        int company=Dependencies.get<SharedPrefService>().getValue(SharedPrefService.company, 0);
        List<CommandEntity> commands=await repository.getCommands(company);
        emit(state.copyWith(fetchDataStatus: AppStatus.success,commands: commands));
      }on NetworkConnectivityException catch(ex){
        emit(state.copyWith(fetchDataStatus: AppStatus.error,isOffline: true));
      }catch(ex){
        emit(state.copyWith(fetchDataStatus: AppStatus.error,));
      }
  }

  void listener(CoreState state) {
    if(state is CommandsUpdated){
      add(FetchCommands());
    }
  }

  @override
  Future<void> close() async{
    await super.close();
    await streamSubscription.cancel();
  }
}
